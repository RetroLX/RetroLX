################################################################################
#
# RetroLX System
#
################################################################################

RETROLX_SYSTEM_SOURCE=

RETROLX_SYSTEM_VERSION = 2022.05-dev
RETROLX_SYSTEM_DATE_TIME = $(shell date "+%Y/%m/%d %H:%M")
RETROLX_SYSTEM_DATE = $(shell date "+%Y/%m/%d")
RETROLX_SYSTEM_DEPENDENCIES = tzdata

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
	RETROLX_SYSTEM_ARCH=rpi3
	RETROLX_SYSTEM_RETROLX_CONF=rpi3
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
	RETROLX_SYSTEM_ARCH=rk3399
	RETROLX_SYSTEM_RETROLX_CONF=rk3399
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y)
	RETROLX_SYSTEM_ARCH=rk3288
	RETROLX_SYSTEM_RETROLX_CONF=rk3288
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_AW32),y)
	RETROLX_SYSTEM_ARCH=aw32
	RETROLX_SYSTEM_RETROLX_CONF=aw32
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES2),y)
	RETROLX_SYSTEM_ARCH=arm64_a53_gles2
	RETROLX_SYSTEM_RETROLX_CONF=arm-a53-gles2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES3),y)
	RETROLX_SYSTEM_ARCH=arm64_a53_gles3
	RETROLX_SYSTEM_RETROLX_CONF=arm-a53-gles3
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A55_GLES3),y)
	RETROLX_SYSTEM_ARCH=arm64_a55_gles3
	RETROLX_SYSTEM_RETROLX_CONF=arm-a55-gles3
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
	RETROLX_SYSTEM_ARCH=s812
	RETROLX_SYSTEM_RETROLX_CONF=s812
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
	RETROLX_SYSTEM_ARCH=s922x
	RETROLX_SYSTEM_RETROLX_CONF=s922x
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326),y)
	RETROLX_SYSTEM_ARCH=rk3326
	RETROLX_SYSTEM_RETROLX_CONF=rk3326
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
	RETROLX_SYSTEM_ARCH=odroidxu4
	RETROLX_SYSTEM_RETROLX_CONF=xu4
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86),y)
	RETROLX_SYSTEM_ARCH=x86
	RETROLX_SYSTEM_RETROLX_CONF=x86
else ifeq ($(BR2_x86_64),y)
	RETROLX_SYSTEM_ARCH=x86_64
	RETROLX_SYSTEM_RETROLX_CONF=x86_64
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
	RETROLX_SYSTEM_ARCH=rpi2
	RETROLX_SYSTEM_RETROLX_CONF=rpi2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI1),y)
	RETROLX_SYSTEM_ARCH=rpi1
	RETROLX_SYSTEM_RETROLX_CONF=rpi1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
	RETROLX_SYSTEM_ARCH=rpi4
	RETROLX_SYSTEM_RETROLX_CONF=rpi4
else
	RETROLX_SYSTEM_ARCH=unknown
	RETROLX_SYSTEM_RETROLX_CONF=unknown
endif

define RETROLX_SYSTEM_INSTALL_TARGET_CMDS

	# version/arch
	mkdir -p $(TARGET_DIR)/usr/share/retrolx
	echo -n "$(RETROLX_SYSTEM_ARCH)" > $(TARGET_DIR)/usr/share/retrolx/retrolx.arch
	echo $(RETROLX_SYSTEM_VERSION) $(RETROLX_SYSTEM_DATE_TIME) > $(TARGET_DIR)/usr/share/retrolx/retrolx.version

	# datainit
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/datainit/system
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-system/retrolx.conf $(TARGET_DIR)/usr/share/retrolx/datainit/system

	# retrolx-boot.conf
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-system/retrolx-boot.conf $(BINARIES_DIR)/retrolx-boot.conf

	# install scripts
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/scripts
	cp -R $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-system/scripts/* $(TARGET_DIR)/usr/share/retrolx/scripts/

	# mounts
	mkdir -p $(TARGET_DIR)/boot $(TARGET_DIR)/overlay $(TARGET_DIR)/userdata

	# variables
	mkdir -p $(TARGET_DIR)/etc/profile.d
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-system/xdg.sh $(TARGET_DIR)/etc/profile.d/xdg.sh
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-system/dbus.sh $(TARGET_DIR)/etc/profile.d/dbus.sh
endef

$(eval $(generic-package))
