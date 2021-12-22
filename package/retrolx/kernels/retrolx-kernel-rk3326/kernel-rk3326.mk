################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_RK3326_VERSION = 5.15.11
RETROLX_KERNEL_RK3326_ARCH = rk3326
RETROLX_KERNEL_RK3326_SOURCE = kernel-$(RETROLX_KERNEL_RK3326_ARCH)-$(RETROLX_KERNEL_RK3326_VERSION).tar.gz
RETROLX_KERNEL_RK3326_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_RK3326_ARCH)/$(RETROLX_KERNEL_RK3326_VERSION)

define RETROLX_KERNEL_RK3326_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RK3326_DL_SUBDIR)/$(RETROLX_KERNEL_RK3326_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
