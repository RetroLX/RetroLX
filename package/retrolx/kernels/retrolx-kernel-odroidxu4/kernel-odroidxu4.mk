################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_ODROIDXU4_VERSION = 5.15.23-1
RETROLX_KERNEL_ODROIDXU4_ARCH = exynos5422
RETROLX_KERNEL_ODROIDXU4_SOURCE = kernel-$(RETROLX_KERNEL_ODROIDXU4_ARCH)-$(RETROLX_KERNEL_ODROIDXU4_VERSION).tar.gz
RETROLX_KERNEL_ODROIDXU4_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_ODROIDXU4_ARCH)/$(RETROLX_KERNEL_ODROIDXU4_VERSION)

define RETROLX_KERNEL_ODROIDXU4_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_ODROIDXU4_DL_SUBDIR)/$(RETROLX_KERNEL_ODROIDXU4_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
