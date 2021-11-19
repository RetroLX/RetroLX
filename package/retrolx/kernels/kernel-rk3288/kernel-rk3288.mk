################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_RK3288_VERSION_VALUE = 5.15.2
KERNEL_RK3288_ARCH = rk3288
KERNEL_RK3288_VERSION = $(KERNEL_RK3288_ARCH)-$(KERNEL_RK3288_VERSION_VALUE)
KERNEL_RK3288_SOURCE = kernel-$(KERNEL_RK3288_ARCH)-$(KERNEL_RK3288_VERSION_VALUE).tar.gz
KERNEL_RK3288_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_RK3288_VERSION)

define KERNEL_RK3288_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_RK3288_DL_SUBDIR)/$(KERNEL_RK3288_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
