################################################################################
#
# mupen64plus video GLIDEN64
#
################################################################################
# Version.: Commits on Nov 6, 2021
MUPEN64PLUS_GLIDEN64_VERSION = 46c58576e2b86e836b86ca43d904eccff6ab0f2f
MUPEN64PLUS_GLIDEN64_SITE = $(call github,gonetz,GLideN64,$(MUPEN64PLUS_GLIDEN64_VERSION))
MUPEN64PLUS_GLIDEN64_LICENSE = GPLv2
MUPEN64PLUS_GLIDEN64_DEPENDENCIES = sdl2 alsa-lib mupen64plus-core
MUPEN64PLUS_GLIDEN64_CONF_OPTS = -DMUPENPLUSAPI=ON -DUSE_SYSTEM_LIBS=ON -DUNIX=ON -DVEC4_OPT=ON
MUPEN64PLUS_GLIDEN64_SUBDIR = /src/

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	MUPEN64PLUS_GLIDEN64_DEPENDENCIES += rpi-userland
endif

ifeq ($(BR2_arm)$(BR2_aarch64),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DEGL=ON
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCMAKE_C_FLAGS="-DEGL_NO_X11"
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCMAKE_CXX_FLAGS="-DEGL_NO_X11"
endif

ifeq ($(BR2_PACKAGE_RETROLX_IS_X86_ARCH),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DX86_OPT=ON
endif

ifeq ($(BR2_PACKAGE_MESA3D),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DMESA=ON
endif

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DNEON_OPT=ON
endif

ifeq ($(BR2_PACKAGE_SDL2_KMSDRM),y)
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DSDL=ON
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
	MUPEN64PLUS_GLIDEN64_RELTYPE= Debug
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
else
	MUPEN64PLUS_GLIDEN64_RELTYPE = Release
	MUPEN64PLUS_GLIDEN64_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
endif

define MUPEN64PLUS_GLIDEN64_INSTALL_TARGET_CMDS
	mkdir -p $(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)/lib/mupen64plus/
	$(INSTALL) -D $(@D)/src/plugin/$(MUPEN64PLUS_GLIDEN64_RELTYPE)/mupen64plus-video-GLideN64.so \
		$(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)/lib/mupen64plus/mupen64plus-video-gliden64.so
	mkdir -p $(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)/share/mupen64plus/
	$(INSTALL) -D $(@D)/ini/* \
		$(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)
endef

define MUPEN64PLUS_GLIDEN64_PRE_CONFIGURE_FIXUP
	chmod +x $(@D)/src/getRevision.sh
	sh $(@D)/src/getRevision.sh
	$(SED) 's|.{CMAKE_FIND_ROOT_PATH}/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/src/CMakeLists.txt
	$(SED) 's|.{CMAKE_FIND_ROOT_PATH}/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/src/CMakeLists.txt
endef

MUPEN64PLUS_GLIDEN64_PRE_CONFIGURE_HOOKS += MUPEN64PLUS_GLIDEN64_PRE_CONFIGURE_FIXUP

$(eval $(cmake-package))
