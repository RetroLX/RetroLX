################################################################################
#
# AMIBERRY
#
################################################################################
# Version.: Release on Jul 1, 2022
AMIBERRY_VERSION = v5.3
AMIBERRY_SITE = $(call github,midwan,amiberry,$(AMIBERRY_VERSION))
AMIBERRY_LICENSE = GPLv3
AMIBERRY_DEPENDENCIES = sdl2 sdl2_image sdl2_ttf mpg123 libxml2 libmpeg2 flac

AMIBERRY_PKG_DIR = $(TARGET_DIR)/opt/retrolx/amiberry
AMIBERRY_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/amiberry

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	AMIBERRY_DEPENDENCIES += rpi-userland
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
	AMIBERRY_RETROLX_SYSTEM=rpi4-64-sdl2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
	AMIBERRY_RETROLX_SYSTEM=rpi3-64-sdl2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
	AMIBERRY_RETROLX_SYSTEM=rpi2-sdl2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI1),y)
	AMIBERRY_RETROLX_SYSTEM=rpi1-sdl2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
	AMIBERRY_RETROLX_SYSTEM=xu4
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
	AMIBERRY_RETROLX_SYSTEM=AMLG12B
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326),y)
	AMIBERRY_RETROLX_SYSTEM=oga
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
	AMIBERRY_RETROLX_SYSTEM=lePotato
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y)
	AMIBERRY_RETROLX_SYSTEM=RK3288
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES2),y)
	AMIBERRY_RETROLX_SYSTEM=AMLGXBB
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES3),y)
	AMIBERRY_RETROLX_SYSTEM=AMLGXM
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A55_GLES3),y)
	AMIBERRY_RETROLX_SYSTEM=AMLSM1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM32_A7_GLES2),y)
	AMIBERRY_RETROLX_SYSTEM=orangepi-pc
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
    AMIBERRY_RETROLX_SYSTEM=s812
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
    AMIBERRY_RETROLX_SYSTEM=x86-64
endif

define AMIBERRY_CONFIGURE_PI
	sed -i "s+/opt/vc+$(STAGING_DIR)/usr+g" $(@D)/Makefile
	sed -i "s+xml2-config+$(STAGING_DIR)/usr/bin/xml2-config+g" $(@D)/Makefile
endef

AMIBERRY_PRE_CONFIGURE_HOOKS += AMIBERRY_CONFIGURE_PI

define AMIBERRY_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) \
		CPP="$(TARGET_CPP)" \
		CXX="$(TARGET_CXX)" \
		CC="$(TARGET_CC)" \
		AS="$(TARGET_CC)" \
		LD="$(TARGET_LD)" \
		STRIP="$(TARGET_STRIP)" \
        SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl2-config \
		-C $(@D) \
		-f Makefile \
		PLATFORM=$(AMIBERRY_RETROLX_SYSTEM)
endef

define AMIBERRY_INSTALL_TARGET_CMDS
endef

define AMIBERRY_MAKEPKG
	# Create directories
	mkdir -p $(AMIBERRY_PKG_DIR)$(AMIBERRY_PKG_INSTALL_DIR)/data
    mkdir -p $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)

	# Copy package files
	cp -pr $(@D)/amiberry $(AMIBERRY_PKG_DIR)$(AMIBERRY_PKG_INSTALL_DIR)
	cp -pr $(@D)/whdboot $(AMIBERRY_PKG_DIR)$(AMIBERRY_PKG_INSTALL_DIR)
	cp -rf $(@D)/data $(AMIBERRY_PKG_DIR)$(AMIBERRY_PKG_INSTALL_DIR)
	cp -prn $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/amiberry/controllers/*.amiberry.keys \
		$(AMIBERRY_PKG_DIR)$(AMIBERRY_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(AMIBERRY_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/amiberry/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

AMIBERRY_POST_INSTALL_TARGET_HOOKS = AMIBERRY_MAKEPKG

$(eval $(generic-package))
