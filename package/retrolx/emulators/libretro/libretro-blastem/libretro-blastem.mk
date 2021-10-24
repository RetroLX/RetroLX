################################################################################
#
# BLASTEM
#
################################################################################
# Version.: Commits on Oct 21, 2021
LIBRETRO_BLASTEM_VERSION = c6ffbe21a169
LIBRETRO_BLASTEM_SOURCE = $(LIBRETRO_BLASTEM_VERSION).tar.gz
LIBRETRO_BLASTEM_SITE = https://www.retrodev.com/repos/blastem/archive
LIBRETRO_BLASTEM_LICENSE = Non-commercial

LIBRETRO_BLASTEM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BLASTEM_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-blastem

LIBRETRO_BLASTEM_EXTRAOPTS=

ifeq ($(BR2_x86_64),y)
LIBRETRO_BLASTEM_EXTRAOPTS=CPU=x86_64
else  ifeq ($(BR2_x86_i686),y)
LIBRETRO_BLASTEM_EXTRAOPTS=CPU=i686
else ifeq ($(BR2_arm),y)
LIBRETRO_BLASTEM_EXTRAOPTS=CPU=arm
else ifeq ($(BR2_aarch64),y)
LIBRETRO_BLASTEM_EXTRAOPTS=CPU=aarch64
else
LIBRETRO_BLASTEM_EXTRAOPTS=CPU=unknown
endif

define LIBRETRO_BLASTEM_BUILD_CMDS
	$(SED) "s+CPU:=i686+CPU?=i686+g" $(@D)/Makefile
	cd $(@D) && ./cpu_dsl.py z80.cpu > z80.c
	cd $(@D) && ./cpu_dsl.py m68k.cpu > m68k.c
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CFLAGS="-DHAS_PROC -DHAVE_UNISTD_H -fPIC -DNEW_CORE -DIS_LIB -std=gnu99" CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) $(LIBRETRO_BLASTEM_EXTRAOPTS) libblastem.so
endef

define LIBRETRO_BLASTEM_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BLASTEM_PKG_DIR)$(LIBRETRO_BLASTEM_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/libblastem.so \
	$(LIBRETRO_BLASTEM_PKG_DIR)$(LIBRETRO_BLASTEM_PKG_INSTALL_DIR)/blastem_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_BLASTEM_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-blastem/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BLASTEM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BLASTEM_MAKEPKG

$(eval $(generic-package))
