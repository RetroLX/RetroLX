################################################################################
#
# CITRA
#
################################################################################
# Version.: Commits on Jun 11, 2022
LIBRETRO_CITRA_VERSION = 8bbea555ed94ca998ebd5b36c6bd3c39f4297be4
LIBRETRO_CITRA_SITE = https://github.com/libretro/citra.git
LIBRETRO_CITRA_SITE_METHOD=git
LIBRETRO_CITRA_GIT_SUBMODULES=YES
LIBRETRO_CITRA_DEPENDENCIES = boost
LIBRETRO_CITRA_LICENSE = GPLv2+

LIBRETRO_CITRA_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_CITRA_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-citra

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
LIBRETRO_CITRA_SUPPORTS_IN_SOURCE_BUILD = NO

LIBRETRO_CITRA_CONF_OPTS  = -DENABLE_LIBRETRO=ON
LIBRETRO_CITRA_CONF_OPTS += -DENABLE_QT=OFF
LIBRETRO_CITRA_CONF_OPTS += -DENABLE_SDL2=OFF
LIBRETRO_CITRA_CONF_OPTS += -DENABLE_WEB_SERVICE=OFF
LIBRETRO_CITRA_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
LIBRETRO_CITRA_CONF_OPTS += -DTHREADS_PTHREAD_ARG=OFF
LIBRETRO_CITRA_CONF_OPTS += -DBUILD_SHARED_LIBS=FALSE

define LIBRETRO_CITRA_INSTALL_TARGET_CMDS
	echo "lr-citra built as package, no rootfs install"
endef

define LIBRETRO_CITRA_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_CITRA_PKG_DIR)$(LIBRETRO_CITRA_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/buildroot-build/src/citra_libretro/citra_libretro.so \
	$(LIBRETRO_CITRA_PKG_DIR)$(LIBRETRO_CITRA_PKG_INSTALL_DIR)/citra_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_CITRA_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-citra/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_CITRA_POST_INSTALL_TARGET_HOOKS = LIBRETRO_CITRA_MAKEPKG

$(eval $(cmake-package))
