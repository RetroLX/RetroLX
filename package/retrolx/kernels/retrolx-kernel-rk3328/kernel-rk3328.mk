################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_RK3328_VERSION_VALUE = 5.15.2
RETROLX_KERNEL_RK3328_ARCH = rk3328
RETROLX_KERNEL_RK3328_VERSION = $(RETROLX_KERNEL_RK3328_ARCH)-$(RETROLX_KERNEL_RK3328_VERSION_VALUE)
RETROLX_KERNEL_RK3328_SOURCE = kernel-$(RETROLX_KERNEL_RK3328_ARCH)-$(RETROLX_KERNEL_RK3328_VERSION_VALUE).tar.gz
RETROLX_KERNEL_RK3328_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_RK3328_VERSION)

define RETROLX_KERNEL_RK3328_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RK3328_DL_SUBDIR)/$(RETROLX_KERNEL_RK3328_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
