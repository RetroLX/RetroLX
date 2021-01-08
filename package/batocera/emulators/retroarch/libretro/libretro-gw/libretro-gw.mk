################################################################################
#
# GW
#
################################################################################
# Version.: Commits on Jan 01, 2020
LIBRETRO_GW_VERSION = 42dc7c0a5a0dc5f35ec61af0a2b08f6e3894589e
LIBRETRO_GW_SITE = $(call github,libretro,gw-libretro,$(LIBRETRO_GW_VERSION))
LIBRETRO_GW_LICENSE = GPLv3

LIBRETRO_GW_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_ODROIDGOA),y)
	LIBRETRO_GW_PLATFORM = classic_armv8_a35
endif

define LIBRETRO_GW_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(LIBRETRO_GW_PLATFORM)"
endef

define LIBRETRO_GW_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/gw_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/gw_libretro.so
endef

$(eval $(generic-package))
