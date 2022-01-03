################################################################################
#
# ps4 initramfs
#
################################################################################

RETROLX_PS4_INITRAMFS_VERSION = 1.00
RETROLX_PS4_INITRAMFS_SITE = http://www.busybox.net/downloads
RETROLX_PS4_INITRAMFS_SOURCE = busybox-$(RETROLX_PS4_INITRAMFS_VERSION).tar.bz2
RETROLX_PS4_INITRAMFS_LICENSE = GPLv2
RETROLX_PS4_INITRAMFS_LICENSE_FILES = LICENSE

RETROLX_PS4_INITRAMFS_CFLAGS = $(TARGET_CFLAGS)
RETROLX_PS4_INITRAMFS_LDFLAGS = $(TARGET_LDFLAGS)

RETROLX_PS4_INITRAMFS_KCONFIG_FILE = $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/boot/retrolx-initramfs/busybox.config

INITRAMFS_DIR=$(BINARIES_DIR)/initramfs

# Allows the build system to tweak CFLAGS
RETROLX_PS4_INITRAMFS_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	CFLAGS="$(RETROLX_PS4_INITRAMFS_CFLAGS)"
RETROLX_PS4_INITRAMFS_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	ARCH=$(KERNEL_ARCH) \
	PREFIX="$(INITRAMFS_DIR)" \
	EXTRA_LDFLAGS="$(RETROLX_PS4_INITRAMFS_LDFLAGS)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CONFIG_PREFIX="$(INITRAMFS_DIR)" \
	SKIP_STRIP=n

RETROLX_PS4_INITRAMFS_KCONFIG_OPTS = $(RETROLX_PS4_INITRAMFS_MAKE_OPTS)

define RETROLX_PS4_INITRAMFS_BUILD_CMDS
	$(RETROLX_PS4_INITRAMFS_MAKE_ENV) $(MAKE) $(RETROLX_PS4_INITRAMFS_MAKE_OPTS) -C $(@D)
endef

define RETROLX_PS4_INITRAMFS_INSTALL_TARGET_CMDS
	mkdir -p $(INITRAMFS_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/boot/retrolx-initramfs/init $(INITRAMFS_DIR)/init
	$(RETROLX_PS4_INITRAMFS_MAKE_ENV) $(MAKE) $(RETROLX_PS4_INITRAMFS_MAKE_OPTS) -C $(@D) install
	(cd $(INITRAMFS_DIR) && find . | cpio -H newc -o > $(BINARIES_DIR)/initrd)
	(cd $(BINARIES_DIR) && $(HOST_DIR)/bin/mkimage -A $(RETROLX_PS4_INITRAMFS_INITRDA) -O linux -T ramdisk -C none -a 0 -e 0 -n initrd -d ./initrd ./uInitrd)
	(cd $(INITRAMFS_DIR) && find . | cpio -H newc -o | gzip -9 > $(BINARIES_DIR)/initrd.gz)
endef

$(eval $(kconfig-package))
