################################################################################
#
# BOX64 emulator
#
################################################################################
# Version.: Release on Nov 19, 2021
BOX64_VERSION = v0.1.6
BOX64_SITE = https://github.com/ptitseb/box64
BOX64_SITE_METHOD=git
BOX64_LICENSE = GPLv3
BOX64_DEPENDENCIES = host-python3

BOX64_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release -DLD80BITS=OFF -DNOALIGN=OFF -DARM_DYNAREC=ON
BOX64_PKG_DIR = $(TARGET_DIR)/opt/retrolx/box64
BOX64_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/box64

define BOX64_INSTALL_TARGET_CMDS
	echo "Box64 built as pacman package, no rootfs install"
endef

define BOX64_MAKEPKG
	# Create directories
	mkdir -p $(BOX64_PKG_DIR)$(BOX64_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/box64 $(BOX64_PKG_DIR)$(BOX64_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(BOX64_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/box86/box64/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

BOX64_POST_INSTALL_TARGET_HOOKS = BOX64_MAKEPKG

$(eval $(cmake-package))
