################################################################################
#
# YABASANSHIRO
#
################################################################################
# Version.: Commits on Feb 4, 2021
LIBRETRO_YABASANSHIRO_VERSION = db67d16c89f4c10f958a0ae72209d6651111007c
LIBRETRO_YABASANSHIRO_SITE = $(call github,libretro,yabause,$(LIBRETRO_YABASANSHIRO_VERSION))
LIBRETRO_YABASANSHIRO_LICENSE = GPLv2
LIBRETRO_YABASANSHIRO_DEPENDENCIES = retroarch

LIBRETRO_YABASANSHIRO_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_YABASANSHIRO_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-yabasanshiro

LIBRETRO_YABASANSHIRO_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS = $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
LIBRETRO_YABASANSHIRO_PLATFORM = odroid
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += BOARD=ODROID-XU4 FORCE_GLES=1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_YABASANSHIRO_PLATFORM = odroid-n2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
LIBRETRO_YABASANSHIRO_PLATFORM = arm64
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += FORCE_GLES=1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_YABASANSHIRO_PLATFORM = rpi4
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += FORCE_GLES=1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H6),y)
LIBRETRO_YABASANSHIRO_PLATFORM = arm64
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += FORCE_GLES=1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_H616),y)
LIBRETRO_YABASANSHIRO_PLATFORM = h616
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += FORCE_GLES=1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y)
LIBRETRO_YABASANSHIRO_PLATFORM = RK3288
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += FORGE_GLES=1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S912),y)
LIBRETRO_YABASANSHIRO_PLATFORM = s912
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += FORCE_GLES=1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN3),y)
LIBRETRO_YABASANSHIRO_PLATFORM = c4
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += FORCE_GLES=1
else ifeq ($(BR2_aarch64),y)
LIBRETRO_YABASANSHIRO_PLATFORM = unix
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += FORCE_GLES=1 arch=arm64 HAVE_SSE=0 ARCH_IS_LINUX=1
LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS += -shared -Wl,--no-undefined -pthread
else ifeq ($(BR2_x86_64),y)
LIBRETRO_YABASANSHIRO_PLATFORM = unix
LIBRETRO_YABASANSHIRO_EXTRA_ARGS += ARCH_IS_LINUX=1
LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS += -shared -Wl,--no-undefined -pthread -lGL
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS += -lmali
endif

define LIBRETRO_YABASANSHIRO_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LDFLAGS="$(LIBRETRO_YABASANSHIRO_TARGET_LDFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
		-C $(@D)/yabause/src/libretro -f Makefile \
		platform="$(LIBRETRO_YABASANSHIRO_PLATFORM)" $(LIBRETRO_YABASANSHIRO_EXTRA_ARGS)
endef

define LIBRETRO_YABASANSHIRO_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_YABASANSHIRO_PKG_DIR)$(LIBRETRO_YABASANSHIRO_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/yabause/src/libretro/yabasanshiro_libretro.so \
	$(LIBRETRO_YABASANSHIRO_PKG_DIR)$(LIBRETRO_YABASANSHIRO_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_YABASANSHIRO_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-yabasanshiro/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_YABASANSHIRO_POST_INSTALL_TARGET_HOOKS = LIBRETRO_YABASANSHIRO_MAKEPKG

$(eval $(generic-package))
