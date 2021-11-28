################################################################################
#
# pacman Package Manager
#
################################################################################

PACMAN_VERSION = 5.2.2
PACMAN_SITE = https://sources.archlinux.org/other/pacman
PACMAN_SOURCES = pacman-$(PACMAN_VERSION).tar.gz
PACMAN_LICENSE = GPLv2
PACMAN_DEPENDENCIES = glibc libarchive libcurl libgpgme openssl host-libarchive host-libcurl

define RETROLX_PACMAN_INSTALL_CONF
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/datainit/system/pacman
	rm -f $(TARGET_DIR)/usr/bin/makepkg
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/batocera_pacman.conf $(TARGET_DIR)/etc/batocera_pacman.conf
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/retrolx_pacman.conf $(TARGET_DIR)/etc/retrolx_pacman.conf
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/install.conf $(TARGET_DIR)/usr/share/retrolx/scripts/install.conf
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/batocera-makepkg $(TARGET_DIR)/usr/bin/batocera-makepkg
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/batocera-pacman-batoexec $(TARGET_DIR)/usr/bin/batocera-pacman-batoexec

	mkdir -p $(TARGET_DIR)/etc/pacman/hooks/batocera
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/batocera-install.hook $(TARGET_DIR)/etc/pacman/hooks/batocera/batocera-install.hook
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/batocera-uninstall.hook $(TARGET_DIR)/etc/pacman/hooks/batocera/batocera-uninstall.hook

	mkdir -p $(TARGET_DIR)/etc/pacman/hooks/retrolx
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/retrolx-install-es-system.hook \
	$(TARGET_DIR)/etc/pacman/hooks/retrolx/retrolx-install-es-system.hook
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/retrolx-uninstall-es-system.hook \
	$(TARGET_DIR)/etc/pacman/hooks/retrolx/retrolx-uninstall-es-system.hook

	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/pacman/userdata_pacman.conf $(TARGET_DIR)/usr/share/retrolx/datainit/system/pacman/pacman.conf
	sed -i -e s+"{RETROLX_ARCHITECTURE}"+"$(RETROLX_SYSTEM_ARCH)"+ $(TARGET_DIR)/etc/batocera_pacman.conf
	sed -i -e s+"{RETROLX_ARCHITECTURE}"+"$(RETROLX_SYSTEM_ARCH)"+ $(TARGET_DIR)/etc/retrolx_pacman.conf
	sed -i -e s+"{RETROLX_ARCHITECTURE}"+"$(RETROLX_SYSTEM_ARCH)"+ $(TARGET_DIR)/usr/share/retrolx/scripts/install.conf
	sed -i -e s+/usr/bin/bash+/bin/bash+ $(TARGET_DIR)/usr/bin/repo-add
endef

PACMAN_POST_INSTALL_TARGET_HOOKS = RETROLX_PACMAN_INSTALL_CONF

$(eval $(autotools-package))
$(eval $(host-autotools-package))
