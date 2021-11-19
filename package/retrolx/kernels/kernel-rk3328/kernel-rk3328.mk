################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_RK3328_VERSION_VALUE = 5.15.2
KERNEL_RK3328_ARCH = rk3328
KERNEL_RK3328_VERSION = $(KERNEL_RK3328_ARCH)-$(KERNEL_RK3328_VERSION_VALUE)
KERNEL_RK3328_SOURCE = kernel-$(KERNEL_RK3328_ARCH)-$(KERNEL_RK3328_VERSION_VALUE).tar.gz
KERNEL_RK3328_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_RK3328_VERSION)

define KERNEL_RK3328_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_RK3328_DL_SUBDIR)/$(KERNEL_RK3328_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
