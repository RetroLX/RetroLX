################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_ODROIDXU4_VERSION_VALUE = 5.15.2
KERNEL_ODROIDXU4_ARCH = exynos5422
KERNEL_ODROIDXU4_VERSION = $(KERNEL_ODROIDXU4_ARCH)-$(KERNEL_ODROIDXU4_VERSION_VALUE)
KERNEL_ODROIDXU4_SOURCE = kernel-$(KERNEL_ODROIDXU4_ARCH)-$(KERNEL_ODROIDXU4_VERSION_VALUE).tar.gz
KERNEL_ODROIDXU4_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_ODROIDXU4_VERSION)

define KERNEL_ODROIDXU4_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_ODROIDXU4_DL_SUBDIR)/$(KERNEL_ODROIDXU4_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
