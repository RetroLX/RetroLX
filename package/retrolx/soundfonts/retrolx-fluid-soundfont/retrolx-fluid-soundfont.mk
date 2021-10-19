################################################################################
#
# retrolx-fluid-soundfont
#
################################################################################

RETROLX_FLUID_SOUNDFONT_VERSION = 3.1
RETROLX_FLUID_SOUNDFONT_SOURCE = fluid-soundfont_$(RETROLX_FLUID_SOUNDFONT_VERSION).orig.tar.gz
# The http://www.hammersound.net archive site seems unreliable (show HTTP 500
# error), and also publish the file in the sfArk format, which is inconvenient
# to be used in automated build. We use here the Debian mirror publishing the
# file in a more convenient format (inative sf2 in a tar.gz archive).
RETROLX_FLUID_SOUNDFONT_SITE = http://http.debian.net/debian/pool/main/f/fluid-soundfont
RETROLX_FLUID_SOUNDFONT_LICENSE = MIT
RETROLX_FLUID_SOUNDFONT_LICENSE_FILES = COPYING

RETROLX_FLUID_SOUNDFONT_PKG_DIR = $(TARGET_DIR)/opt/retrolx/fluid-soundfont
RETROLX_FLUID_SOUNDFONT_PKG_INSTALL_DIR = /userdata/packages/data/fluid-soundfont

define RETROLX_FLUID_SOUNDFONT_MAKEPKG
	# Copy data to proper directory
	mkdir -p $(RETROLX_FLUID_SOUNDFONT_PKG_DIR)$(RETROLX_FLUID_SOUNDFONT_PKG_INSTALL_DIR)
	$(INSTALL) -D -m 0644 $(@D)/FluidR3_GM.sf2 $(RETROLX_FLUID_SOUNDFONT_PKG_DIR)$(RETROLX_FLUID_SOUNDFONT_PKG_INSTALL_DIR)/FluidR3_GM.sf2

	# Build Pacman package
	cd $(RETROLX_FLUID_SOUNDFONT_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/soundfonts/retrolx-fluid-soundfont/PKGINFO \
	any $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

RETROLX_FLUID_SOUNDFONT_POST_INSTALL_TARGET_HOOKS = RETROLX_FLUID_SOUNDFONT_MAKEPKG

$(eval $(generic-package))
