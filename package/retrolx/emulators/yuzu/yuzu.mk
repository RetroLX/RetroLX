################################################################################
#
# YUZU
#
################################################################################
# Version.: Commits on Dec 15, 2021
YUZU_VERSION = EA-2316
YUZU_SITE = https://github.com/pineappleEA/pineapple-src.git
#YUZU_VERSION = mainline-0-775
#YUZU_SITE = https://github.com/yuzu-emu/yuzu-mainline.git
YUZU_SITE_METHOD=git
YUZU_GIT_SUBMODULES=YES
YUZU_LICENSE = GPLv2
YUZU_DEPENDENCIES = qt5base qt5tools qt5multimedia fmt boost ffmpeg zstd zlib libzip lz4 catch2 sdl2 opus

ifeq ($(BR2_PACKAGE_VULKAN_HEADERS)$(BR2_PACKAGE_VULKAN_LOADER),yy)
YUZU_DEPENDENCIES += host-glslang
endif

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
YUZU_SUPPORTS_IN_SOURCE_BUILD = NO

YUZU_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
YUZU_CONF_OPTS += -DYUZU_USE_EXTERNAL_SDL2=OFF
YUZU_CONF_OPTS += -DYUZU_USE_BUNDLED_SDL2=ON
YUZU_CONF_OPTS += -DENABLE_SDL2=ON
YUZU_CONF_OPTS += -DARCHITECTURE_x86_64=ON
YUZU_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
YUZU_CONF_OPTS += -DUSE_DISCORD_PRESENCE=OFF

YUZU_CONF_ENV += LDFLAGS=-lpthread ARCHITECTURE_x86_64=1

define YUZU_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)/usr/bin
        mkdir -p $(TARGET_DIR)/usr/lib/yuzu

        $(INSTALL) -D $(@D)/buildroot-build/bin/yuzu $(TARGET_DIR)/usr/bin/
        $(INSTALL) -D $(@D)/buildroot-build/bin/yuzu-cmd $(TARGET_DIR)/usr/bin/

        #evmap config
        mkdir -p $(TARGET_DIR)/usr/share/evmapy
        cp -prn $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/yuzu/switch.yuzu.keys $(TARGET_DIR)/usr/share/evmapy
endef

$(eval $(cmake-package))
