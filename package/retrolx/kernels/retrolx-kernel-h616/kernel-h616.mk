################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_H616_VERSION_VALUE = 5.15.5
RETROLX_KERNEL_H616_ARCH = h616
RETROLX_KERNEL_H616_VERSION = $(RETROLX_KERNEL_H616_ARCH)-$(RETROLX_KERNEL_H616_VERSION_VALUE)
RETROLX_KERNEL_H616_SOURCE = kernel-$(RETROLX_KERNEL_H616_ARCH)-$(RETROLX_KERNEL_H616_VERSION_VALUE).tar.gz
RETROLX_KERNEL_H616_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_H616_VERSION)

define RETROLX_KERNEL_H616_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_H616_DL_SUBDIR)/$(RETROLX_KERNEL_H616_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
