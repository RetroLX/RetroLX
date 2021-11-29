################################################################################
#
# batocera shaders
#
################################################################################

RETROLX_SHADERS_VERSION = 1.0
RETROLX_SHADERS_SOURCE=
RETROLX_SHADERS_DEPENDENCIES= glsl-shaders

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI1),y)
	RETROLX_SHADERS_SYSTEM=rpi1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
	RETROLX_SHADERS_SYSTEM=rpi2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
	RETROLX_SHADERS_SYSTEM=rpi3
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
	RETROLX_SHADERS_SYSTEM=xu4
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN3),y)
	RETROLX_SHADERS_SYSTEM=c4
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
	RETROLX_SHADERS_SYSTEM=s812
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES2),y)
	RETROLX_SHADERS_SYSTEM=s905
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES3),y)
	RETROLX_SHADERS_SYSTEM=s905gen2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86)$(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
	RETROLX_SHADERS_SYSTEM=x86
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y)
	RETROLX_SHADERS_SYSTEM=rk3288
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
	RETROLX_SHADERS_SYSTEM=rk3399
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK356X),y)
	RETROLX_SHADERS_SYSTEM=rk356x
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
	RETROLX_SHADERS_SYSTEM=odroidn2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_AW32),y)
	RETROLX_SHADERS_SYSTEM=aw32
endif

RETROLX_SHADERS_DIRIN=$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-shaders/configs

define RETROLX_SHADERS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/shaders/configs

	# general
	cp $(RETROLX_SHADERS_DIRIN)/rendering-defaults.yml           $(TARGET_DIR)/usr/share/retrolx/shaders/configs/
	if test -e $(RETROLX_SHADERS_DIRIN)/rendering-defaults-$(RETROLX_SHADERS_SYSTEM).yml; then \
		cp $(RETROLX_SHADERS_DIRIN)/rendering-defaults-$(RETROLX_SHADERS_SYSTEM).yml $(TARGET_DIR)/usr/share/retrolx/shaders/configs/rendering-defaults-arch.yml; \
	fi

	# sets
	for set in retro scanlines enhanced curvature zfast flatten-glow; do \
		mkdir -p $(TARGET_DIR)/usr/share/retrolx/shaders/configs/$$set; \
		cp $(RETROLX_SHADERS_DIRIN)/$$set/rendering-defaults.yml     $(TARGET_DIR)/usr/share/retrolx/shaders/configs/$$set/; \
		if test -e $(RETROLX_SHADERS_DIRIN)/$$set/rendering-defaults-$(RETROLX_SHADERS_SYSTEM).yml; then \
			cp $(RETROLX_SHADERS_DIRIN)/$$set/rendering-defaults-$(RETROLX_SHADERS_SYSTEM).yml $(TARGET_DIR)/usr/share/retrolx/shaders/configs/$$set/rendering-defaults-arch.yml; \
		fi \
	done

endef

$(eval $(generic-package))
