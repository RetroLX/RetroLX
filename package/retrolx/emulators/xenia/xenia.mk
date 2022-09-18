################################################################################
#
# XENIA
#
################################################################################
# Version.: Commits on Sep 15, 2022
XENIA_VERSION = addd8c94e552fac386eced5411487d816afcffe8
XENIA_SITE = https://github.com/xenia-project/xenia
XENIA_SITE_METHOD=git
XENIA_GIT_SUBMODULES=YES
XENIA_LICENSE = GPLv2
XENIA_DEPENDENCIES =

ifeq ($(BR2_PACKAGE_VULKAN_HEADERS)$(BR2_PACKAGE_VULKAN_LOADER),yy)
XENIA_DEPENDENCIES += host-glslang
endif

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
XENIA_SUPPORTS_IN_SOURCE_BUILD = NO

XENIA_CONF_ENV += LDFLAGS=-lpthread ARCHITECTURE_x86_64=1

define XENIA_BUILD_CMDS
	cd $(@D) && \
	SYSROOT="$(STAGING_DIR)" \
        CFLAGS="--sysroot=$(STAGING_DIR) $(MAME_CFLAGS)"   \
        LDFLAGS="--sysroot=$(STAGING_DIR)" \
        PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config --define-prefix" \
        PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig" \
        CC="$(TARGET_CC)" \
        CXX="$(TARGET_CXX)" \
        LD="$(TARGET_LD)" \
        AR="$(TARGET_AR)" \
        STRIP="$(TARGET_STRIP)" \
	./xenia-build build --config release
endef

define XENIA_INSTALL_TARGET_CMDS
        #mkdir -p $(TARGET_DIR)/usr/bin
        #mkdir -p $(TARGET_DIR)/usr/lib/yuzu

        #$(INSTALL) -D $(@D)/buildroot-build/bin/yuzu $(TARGET_DIR)/usr/bin/
        #$(INSTALL) -D $(@D)/buildroot-build/bin/yuzu-cmd $(TARGET_DIR)/usr/bin/

        #evmap config
        #mkdir -p $(TARGET_DIR)/usr/share/evmapy
        #cp -prn $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/yuzu/switch.yuzu.keys $(TARGET_DIR)/usr/share/evmapy
endef

$(eval $(generic-package))
