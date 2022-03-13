################################################################################
#
# FLATPAK
#
################################################################################

FLATPAK_VERSION = 1.12.6
FLATPAK_SOURCE = flatpak-$(FLATPAK_VERSION).tar.xz
FLATPAK_SITE = https://github.com/flatpak/flatpak/releases/download/$(FLATPAK_VERSION)

FLATPAK_DEPENDENCIES += pkgconf host-pkgconf libcap libarchive libglib2 libsoup libgpgme polkit
FLATPAK_DEPENDENCIES += libostree json-glib appstream-glib yaml-cpp
FLATPAK_DEPENDENCIES += python-pyparsing host-python-pyparsing glib-networking libseccomp

FLATPAK_CONF_OPTS += --with-sysroot="$(STAGING_DIR)"
FLATPAK_CONF_OPTS += --with-gpgme-prefix="$(STAGING_DIR)/usr"
FLATPAK_CONF_OPTS += --with-system-install-dir="/userdata/saves/flatpak/binaries"
FLATPAK_CONF_OPTS += --with-run-media-dir="/media"
FLATPAK_CONF_OPTS += --disable-selinux-module

FLATPAK_CONF_ENV += LDFLAGS=-lpthread


define FLATPAK_INSTALL_SCRIPTS
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/flatpak/retrolx-flatpak-update $(TARGET_DIR)/usr/bin/
endef

FLATPAK_POST_INSTALL_TARGET_HOOKS += FLATPAK_INSTALL_SCRIPTS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
