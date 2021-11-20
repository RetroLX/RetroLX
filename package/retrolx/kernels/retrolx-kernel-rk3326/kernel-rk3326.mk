################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_RK3326_VERSION_VALUE = 5.15.2
RETROLX_KERNEL_RK3326_ARCH = rk3326
RETROLX_KERNEL_RK3326_VERSION = $(RETROLX_KERNEL_RK3326_ARCH)-$(RETROLX_KERNEL_RK3326_VERSION_VALUE)
RETROLX_KERNEL_RK3326_SOURCE = kernel-$(RETROLX_KERNEL_RK3326_ARCH)-$(RETROLX_KERNEL_RK3326_VERSION_VALUE).tar.gz
RETROLX_KERNEL_RK3326_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_RK3326_VERSION)

define RETROLX_KERNEL_RK3326_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RK3326_DL_SUBDIR)/$(RETROLX_KERNEL_RK3326_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
