################################################################################
#
# MUPEN64PLUS
#
################################################################################
MUPEN64PLUS_VERSION = 20211106
MUPEN64PLUS_DEPENDENCIES = mupen64plus-core mupen64plus-uiconsole mupen64plus-input-sdl mupen64plus-rsphle
ifeq  ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
MUPEN64PLUS_DEPENDENCIES += mupen64plus-omx
else
MUPEN64PLUS_DEPENDENCIES += mupen64plus-audio-sdl
endif

ifeq ($(BR2_PACKAGE_RETROLX_HAS_GLES2),y)
ifeq ($(BR2_arm),y)
MUPEN64PLUS_DEPENDENCIES += mupen64plus-gles2
endif
else
MUPEN64PLUS_DEPENDENCIES += mupen64plus-gliden64
MUPEN64PLUS_DEPENDENCIES += mupen64plus-video-glide64mk2
endif

ifeq ($(BR2_PACKAGE_RETROLX_IS_X86_ARCH)$(BR2_PACKAGE_RETROLX_HAS_GLES3),y)
MUPEN64PLUS_DEPENDENCIES += mupen64plus-video-rice
endif

MUPEN64PLUS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/mupen64plus
MUPEN64PLUS_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/mupen64plus

define MUPEN64PLUS_BUILD_CMDS
endef

define MUPEN64PLUS_INSTALL_TARGET_CMDS
endef

define MUPEN64PLUS_MAKEPKG
	# Create directories
	mkdir -p $(MUPEN64PLUS_PKG_DIR)$(MUPEN64PLUS_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(MUPEN64PLUS_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/mupen64plus/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

MUPEN64PLUS_POST_INSTALL_TARGET_HOOKS = MUPEN64PLUS_MAKEPKG

$(eval $(virtual-package))
