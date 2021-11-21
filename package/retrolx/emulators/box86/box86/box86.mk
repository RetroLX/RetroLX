################################################################################
#
# Box86 emulator
#
################################################################################
# Version.: Release on Nov 19, 2021
BOX86_VERSION = v0.2.4
BOX86_SITE = https://github.com/ptitseb/box86
BOX86_SITE_METHOD=git
BOX86_LICENSE = GPLv3
BOX86_DEPENDENCIES = host-python3

BOX86_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release -DLD80BITS=OFF -DNOALIGN=OFF -DARM_DYNAREC=ON
BOX86_PKG_DIR = $(TARGET_DIR)/opt/retrolx/box86
BOX86_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/box86

define BOX86_INSTALL_TARGET_CMDS
	echo "Box86 built as pacman package, no rootfs install"
endef

define BOX86_MAKEPKG
	# Create directories
	mkdir -p $(BOX86_PKG_DIR)$(BOX86_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/box86 $(BOX86_PKG_DIR)$(BOX86_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(BOX86_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/box86/box86/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

BOX86_POST_INSTALL_TARGET_HOOKS = BOX86_MAKEPKG

$(eval $(cmake-package))
