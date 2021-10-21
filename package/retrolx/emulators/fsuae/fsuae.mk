################################################################################
#
# FSUAE
#
################################################################################
# Version.: Release on Oct 11, 2021
FSUAE_VERSION = v3.1.35
FSUAE_SITE = $(call github,FrodeSolheim,fs-uae,$(FSUAE_VERSION))
FSUAE_LICENSE = GPLv2
FSUAE_DEPENDENCIES = xserver_xorg-server openal libpng sdl2 zlib libmpeg2 libglib2 libcapsimage

FSUAE_CONF_OPTS += --disable-codegen

define FSUAE_HOOK_BOOTSTRAP
  cd $(@D) && ./bootstrap
endef

FSUAE_PRE_CONFIGURE_HOOKS += FSUAE_HOOK_BOOTSTRAP

$(eval $(autotools-package))
