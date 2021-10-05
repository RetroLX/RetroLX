################################################################################
#
# mupen64plus core
#
################################################################################
# Version.: Commits on Sep 23, 2021
MUPEN64PLUS_CORE_VERSION = 12eb4ddfeac0a5038c033d0dc212be90d2172170
MUPEN64PLUS_CORE_SITE = $(call github,mupen64plus,mupen64plus-core,$(MUPEN64PLUS_CORE_VERSION))
MUPEN64PLUS_CORE_LICENSE = GPLv2
MUPEN64PLUS_CORE_DEPENDENCIES = sdl2 alsa-lib freetype dejavu
MUPEN64PLUS_CORE_INSTALL_STAGING = YES

MUPEN64PLUS_GL_CFLAGS = -I$(STAGING_DIR)/usr/include -L$(STAGING_DIR)/usr/lib

ifeq ($(BR2_PACKAGE_LIBGLU),y)
	MUPEN64PLUS_CORE_DEPENDENCIES += libglu
	MUPEN64PLUS_GL_LDLIBS = -lGL
else
	MUPEN64PLUS_GL_LDLIBS = -lGLESv2 -lEGL
	MUPEN64PLUS_PARAMS = USE_GLES=1
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	MUPEN64PLUS_CORE_DEPENDENCIES += rpi-userland
	MUPEN64PLUS_GL_LDLIBS = -lbcm_host
	MUPEN64PLUS_PARAMS = VC=1
endif

ifeq ($(BR2_arm),y)
	ifeq ($(BR2_ARM_CPU_ARMV8A),y)
		MUPEN64PLUS_HOST_CPU = armv8
	else
		MUPEN64PLUS_HOST_CPU = armv7
	endif
	MUPEN64PLUS_PARAMS += VFP_HARD=1
endif

ifeq ($(BR2_aarch64),y)
	MUPEN64PLUS_HOST_CPU = aarch64
	MUPEN64PLUS_PARAMS += VFP_HARD=1
endif

ifeq ($(BR2_arm)$(BR2_ARM_CPU_HAS_NEON),yy)
	MUPEN64PLUS_CORE_CPUFLAGS += -marm -DNO_ASM -DARM -D__arm__ -DARM_ASM -D__NEON_OPT -DNOSSE
	MUPEN64PLUS_GL_CFLAGS += -D__ARM_NEON__ -D__NEON_OPT -ftree-vectorize -mvectorize-with-neon-quad -ftree-vectorizer-verbose=2 -funsafe-math-optimizations -fno-finite-math-only

	ifeq ($(BR2_ARM_CPU_HAS_VFPV4),y)
		MUPEN64PLUS_CORE_CPUFLAGS += -mfpu=neon-vfpv4
	else
		MUPEN64PLUS_CORE_CPUFLAGS += -mfpu=neon
	endif

	ifeq ($(BR2_GCC_TARGET_FLOAT_ABI),"hard")
		MUPEN64PLUS_CORE_CPUFLAGS += -mfloat-abi=hard
	endif

	MUPEN64PLUS_PARAMS += NEON=1 CPUFLAGS="$(MUPEN64PLUS_CORE_CPUFLAGS)"
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86),y)
	MUPEN64PLUS_HOST_CPU = i586
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
	MUPEN64PLUS_HOST_CPU = x86_64
endif

ifeq ($(BR2_PACKAGE_RETROLX_ROCKCHIP_ANY),y)
	MUPEN64PLUS_PARAMS += ARCH=arm NEW_DYNAREC=1 VFP=1 CRC_OPT=1 TRIBUFFER_OPT=1 NO_SSE=1 PIC=1 USE_FRAMESKIPPER=1
	MUPEN64PLUS_GL_CFLAGS += -I$(STAGING_DIR)/usr/include/libdrm -ldrm -fpermissive -DEGL_NO_X11=1 -DMESA_EGL_NO_X11_HEADERS=1
endif

define MUPEN64PLUS_CORE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
		AS="$(HOST_DIR)/bin/nasm" \
		PREFIX="$(STAGING_DIR)/usr" \
		PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
		HOST_CPU="$(MUPEN64PLUS_HOST_CPU)" \
		-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)"
endef

define MUPEN64PLUS_CORE_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
		PREFIX="$(STAGING_DIR)/usr" \
		PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
		HOST_CPU="$(MUPEN64PLUS_HOST_CPU)" \
		INSTALL="/usr/bin/install" \
		INSTALL_STRIP_FLAG="" \
		-C $(@D)/projects/unix all $(MUPEN64PLUS_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)" install
endef

define MUPEN64PLUS_CORE_INSTALL_TARGET_CMDS
	mkdir -p $(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)/lib
	$(INSTALL) -m 0644 $(@D)/projects/unix/libmupen64plus.so.2.0.0 $(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)/lib
	mkdir -p $(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)/share/mupen64plus
	ln -sf /usr/share/fonts/dejavu/DejaVuSans.ttf $(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)//share/mupen64plus/font.ttf
	cp $(@D)/data/mupen64plus.ini $(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)/share/mupen64plus/mupen64plus.ini
	cp $(@D)/data/mupencheat.txt "$(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)/share/mupen64plus//mupencheat.txt"

	# input.xml
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/datainit/system/configs/mupen64
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/mupen64plus/mupen64plus-core/controllers/input.xml \
		$(TARGET_DIR)/usr/share/retrolx/datainit/system/configs/mupen64
endef

define MUPEN64PLUS_CORE_CROSS_FIXUP
	$(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/projects/unix/Makefile
	$(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/projects/unix/Makefile
endef
MUPEN64PLUS_CORE_PRE_CONFIGURE_HOOKS += MUPEN64PLUS_CORE_CROSS_FIXUP

$(eval $(generic-package))
