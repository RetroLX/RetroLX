################################################################################
#
# busybox_initramfs
#
################################################################################

RETROLX_INITRAMFS_VERSION = 1.35.0
RETROLX_INITRAMFS_SITE = http://www.busybox.net/downloads
RETROLX_INITRAMFS_SOURCE = busybox-$(RETROLX_INITRAMFS_VERSION).tar.bz2
RETROLX_INITRAMFS_LICENSE = GPLv2
RETROLX_INITRAMFS_LICENSE_FILES = LICENSE

RETROLX_INITRAMFS_CFLAGS = $(TARGET_CFLAGS)
RETROLX_INITRAMFS_LDFLAGS = $(TARGET_LDFLAGS)

RETROLX_INITRAMFS_KCONFIG_FILE = $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/boot/retrolx-initramfs/busybox.config

INITRAMFS_DIR=$(BINARIES_DIR)/initramfs

# Allows the build system to tweak CFLAGS
RETROLX_INITRAMFS_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	CFLAGS="$(RETROLX_INITRAMFS_CFLAGS)"
RETROLX_INITRAMFS_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	ARCH=$(KERNEL_ARCH) \
	PREFIX="$(INITRAMFS_DIR)" \
	EXTRA_LDFLAGS="$(RETROLX_INITRAMFS_LDFLAGS)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CONFIG_PREFIX="$(INITRAMFS_DIR)" \
	SKIP_STRIP=n

RETROLX_INITRAMFS_KCONFIG_OPTS = $(RETROLX_INITRAMFS_MAKE_OPTS)

define RETROLX_INITRAMFS_BUILD_CMDS
	$(RETROLX_INITRAMFS_MAKE_ENV) $(MAKE) $(RETROLX_INITRAMFS_MAKE_OPTS) -C $(@D)
endef

ifeq ($(BR2_aarch64),y)
RETROLX_INITRAMFS_INITRDA=arm64
else
RETROLX_INITRAMFS_INITRDA=arm
endif

define RETROLX_INITRAMFS_INSTALL_TARGET_CMDS
	mkdir -p $(INITRAMFS_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/boot/retrolx-initramfs/init $(INITRAMFS_DIR)/init
	$(RETROLX_INITRAMFS_MAKE_ENV) $(MAKE) $(RETROLX_INITRAMFS_MAKE_OPTS) -C $(@D) install
	(cd $(INITRAMFS_DIR) && find . | cpio -H newc -o > $(BINARIES_DIR)/initrd)
	(cd $(BINARIES_DIR) && $(HOST_DIR)/bin/mkimage -A $(RETROLX_INITRAMFS_INITRDA) -O linux -T ramdisk -C none -a 0 -e 0 -n initrd -d ./initrd ./uInitrd)
	(cd $(INITRAMFS_DIR) && find . | cpio -H newc -o | gzip -9 > $(BINARIES_DIR)/initrd.gz)
endef

$(eval $(kconfig-package))
