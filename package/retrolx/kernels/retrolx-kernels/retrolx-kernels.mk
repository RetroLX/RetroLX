################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNELS_VERSION_VALUE = 5.15.2
ifeq ($(RETROLX_SYSTEM_ARCH),rpi1)
RETROLX_KERNELS_VERSION_VALUE = 5.15.1
else ifeq ($(RETROLX_SYSTEM_ARCH),rpi2)
RETROLX_KERNELS_VERSION_VALUE = 5.15.1
else ifeq ($(RETROLX_SYSTEM_ARCH),rpi3)
RETROLX_KERNELS_VERSION_VALUE = 5.15.1
else ifeq ($(RETROLX_SYSTEM_ARCH),rpi4)
RETROLX_KERNELS_VERSION_VALUE = 5.15.1
endif

# Custom kernels
ifeq ($(RETROLX_SYSTEM_ARCH),rk356x)
RETROLX_KERNELS_VERSION_VALUE = 20211117
endif

# Aliases
RETROLX_KERNELS_ARCH = $(RETROLX_SYSTEM_ARCH)
ifeq ($(RETROLX_SYSTEM_ARCH),odroidxu4)
RETROLX_KERNELS_ARCH = exynos5422
else ifeq ($(RETROLX_SYSTEM_ARCH),s905)
RETROLX_KERNELS_ARCH = meson64
else ifeq ($(RETROLX_SYSTEM_ARCH),s905gen2)
RETROLX_KERNELS_ARCH = meson64
else ifeq ($(RETROLX_SYSTEM_ARCH),h5)
RETROLX_KERNELS_ARCH = sun50i
else ifeq ($(RETROLX_SYSTEM_ARCH),h6)
RETROLX_KERNELS_ARCH = sun50i
endif

RETROLX_KERNELS_VERSION = $(RETROLX_KERNELS_ARCH)-$(RETROLX_KERNELS_VERSION_VALUE)
RETROLX_KERNELS_SOURCE = kernel-$(RETROLX_KERNELS_ARCH)-$(RETROLX_KERNELS_VERSION_VALUE).tar.gz
RETROLX_KERNELS_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNELS_VERSION)

define RETROLX_KERNELS_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNELS_DL_SUBDIR)/$(RETROLX_KERNELS_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
