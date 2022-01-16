################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_RK3399_VERSION = 5.15.15
RETROLX_KERNEL_RK3399_ARCH = rk3399
RETROLX_KERNEL_RK3399_SOURCE = kernel-$(RETROLX_KERNEL_RK3399_ARCH)-$(RETROLX_KERNEL_RK3399_VERSION).tar.gz
RETROLX_KERNEL_RK3399_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_RK3399_ARCH)/$(RETROLX_KERNEL_RK3399_VERSION)

define RETROLX_KERNEL_RK3399_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RK3399_DL_SUBDIR)/$(RETROLX_KERNEL_RK3399_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
