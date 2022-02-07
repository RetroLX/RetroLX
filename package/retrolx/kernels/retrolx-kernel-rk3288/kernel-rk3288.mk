################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_RK3288_VERSION = 5.15.21-1
RETROLX_KERNEL_RK3288_ARCH = rk3288
RETROLX_KERNEL_RK3288_SOURCE = kernel-$(RETROLX_KERNEL_RK3288_ARCH)-$(RETROLX_KERNEL_RK3288_VERSION).tar.gz
RETROLX_KERNEL_RK3288_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_RK3288_ARCH)/$(RETROLX_KERNEL_RK3288_VERSION)

define RETROLX_KERNEL_RK3288_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RK3288_DL_SUBDIR)/$(RETROLX_KERNEL_RK3288_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
