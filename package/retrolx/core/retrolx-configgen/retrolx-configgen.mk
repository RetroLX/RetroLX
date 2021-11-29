################################################################################
#
# retrolx configgen
#
################################################################################

RETROLX_CONFIGGEN_VERSION = 1.4
RETROLX_CONFIGGEN_LICENSE = GPL
RETROLX_CONFIGGEN_SOURCE=
RETROLX_CONFIGGEN_DEPENDENCIES = python3 python-pyyaml
RETROLX_CONFIGGEN_INSTALL_STAGING = YES

define RETROLX_CONFIGGEN_EXTRACT_CMDS
	cp -R $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-configgen/configgen/* $(@D)
endef

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI1),y)
	RETROLX_CONFIGGEN_SYSTEM=rpi1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
	RETROLX_CONFIGGEN_SYSTEM=rpi2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
	RETROLX_CONFIGGEN_SYSTEM=rpi3
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
	RETROLX_CONFIGGEN_SYSTEM=rpi4
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
	RETROLX_CONFIGGEN_SYSTEM=odroidxu4
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y)
	RETROLX_CONFIGGEN_SYSTEM=rk3288
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN3),y)
	RETROLX_CONFIGGEN_SYSTEM=s905gen3
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86),y)
	RETROLX_CONFIGGEN_SYSTEM=x86
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
	RETROLX_CONFIGGEN_SYSTEM=x86_64
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
	RETROLX_CONFIGGEN_SYSTEM=rk3399
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK356X),y)
	RETROLX_CONFIGGEN_SYSTEM=rk356x
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
	RETROLX_CONFIGGEN_SYSTEM=s922x
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326),y)
	RETROLX_CONFIGGEN_SYSTEM=rk3326
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_AW32),y)
	RETROLX_CONFIGGEN_SYSTEM=aw32
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES2),y)
	RETROLX_CONFIGGEN_SYSTEM=arm64-a53-gles2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES3),y)
	RETROLX_CONFIGGEN_SYSTEM=arm64-a53-gles3
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
	RETROLX_CONFIGGEN_SYSTEM=s812
endif

define RETROLX_CONFIGGEN_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/share/retrolx/configgen
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-configgen/configs/configgen-defaults.yml $(STAGING_DIR)/usr/share/retrolx/configgen/configgen-defaults.yml
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-configgen/configs/configgen-defaults-$(RETROLX_CONFIGGEN_SYSTEM).yml $(STAGING_DIR)/usr/share/retrolx/configgen/configgen-defaults-arch.yml
endef

define RETROLX_CONFIGGEN_CONFIGS
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/configgen
	cp -pr $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-configgen/datainit $(TARGET_DIR)/usr/lib/python3.9/site-packages/configgen/
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-configgen/configs/configgen-defaults.yml $(TARGET_DIR)/usr/share/retrolx/configgen/configgen-defaults.yml
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-configgen/configs/configgen-defaults-$(RETROLX_CONFIGGEN_SYSTEM).yml $(TARGET_DIR)/usr/share/retrolx/configgen/configgen-defaults-arch.yml
endef
RETROLX_CONFIGGEN_POST_INSTALL_TARGET_HOOKS = RETROLX_CONFIGGEN_CONFIGS

RETROLX_CONFIGGEN_SETUP_TYPE = distutils

$(eval $(python-package))
