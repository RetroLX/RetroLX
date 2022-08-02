################################################################################
#
# FSUAE
#
################################################################################
# Version.: Commits on Jul 28, 2022 (4.0.x)
FSUAE_VERSION = bfa0c7522c6c5f73cceb340d677491d056febd01
FSUAE_SITE = $(call github,FrodeSolheim,fs-uae,$(FSUAE_VERSION))
FSUAE_LICENSE = GPLv2
FSUAE_DEPENDENCIES = openal libpng sdl2 zlib libmpeg2 libglib2 libcapsimage

FSUAE_CONF_OPTS += --disable-codegen

ifeq ($(BR2_PACKAGE_XORG7),y)
FSUAE_DEPENDENCIES += xserver_xorg-server
else
FSUAE_CONF_OPTS += --without-x11
endif

define FSUAE_HOOK_BOOTSTRAP
  cd $(@D) && ./bootstrap
endef

FSUAE_PRE_CONFIGURE_HOOKS += FSUAE_HOOK_BOOTSTRAP

$(eval $(autotools-package))
