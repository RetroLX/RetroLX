################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
ifeq ($(BR2_i686)$(BR2_x86_64),y)
RETROLX_KERNELS_VERSION_VALUE = 5.13.10
else
RETROLX_KERNELS_VERSION_VALUE = 5.10.58
endif

# Raspberry pi kernels
ifeq ($(RETROLX_SYSTEM_ARCH),rpi1)
RETROLX_KERNELS_VERSION_VALUE = 5.10.52
else ifeq ($(RETROLX_SYSTEM_ARCH),rpi2)
RETROLX_KERNELS_VERSION_VALUE = 5.10.52
else ifeq ($(RETROLX_SYSTEM_ARCH),rpi3)
RETROLX_KERNELS_VERSION_VALUE = 5.10.52
else ifeq ($(RETROLX_SYSTEM_ARCH),rpi4)
RETROLX_KERNELS_VERSION_VALUE = 5.10.52
endif

# Custom kernels
ifeq ($(RETROLX_SYSTEM_ARCH),s812)
RETROLX_KERNELS_VERSION_VALUE = 20210801
endif
ifeq ($(RETROLX_SYSTEM_ARCH),h616)
RETROLX_KERNELS_VERSION_VALUE = 20210730
endif

RETROLX_KERNELS_ARCH = $(RETROLX_SYSTEM_ARCH)
ifeq ($(RETROLX_SYSTEM_ARCH),s905gen3)
RETROLX_KERNELS_ARCH = sm1
endif
ifeq ($(RETROLX_SYSTEM_ARCH),odroidxu4)
RETROLX_KERNELS_ARCH = exynos5422
endif

RETROLX_KERNELS_VERSION = $(RETROLX_KERNELS_ARCH)-$(RETROLX_KERNELS_VERSION_VALUE)
RETROLX_KERNELS_SOURCE = kernel-$(RETROLX_KERNELS_ARCH)-$(RETROLX_KERNELS_VERSION_VALUE).tar.gz
RETROLX_KERNELS_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNELS_VERSION)

define RETROLX_KERNELS_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNELS_DL_SUBDIR)/$(RETROLX_KERNELS_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
