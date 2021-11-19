################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_H616_VERSION_VALUE = 5.15.2
KERNEL_H616_ARCH = h616
KERNEL_H616_VERSION = $(KERNEL_H616_ARCH)-$(KERNEL_H616_VERSION_VALUE)
KERNEL_H616_SOURCE = kernel-$(KERNEL_H616_ARCH)-$(KERNEL_H616_VERSION_VALUE).tar.gz
KERNEL_H616_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_H616_VERSION)

define KERNEL_H616_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_H616_DL_SUBDIR)/$(KERNEL_H616_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
