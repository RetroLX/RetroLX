################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_AW32_VERSION_VALUE = 5.15.2
KERNEL_AW32_ARCH = aw32
KERNEL_AW32_VERSION = $(KERNEL_AW32_ARCH)-$(KERNEL_AW32_VERSION_VALUE)
KERNEL_AW32_SOURCE = kernel-$(KERNEL_AW32_ARCH)-$(KERNEL_AW32_VERSION_VALUE).tar.gz
KERNEL_AW32_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_AW32_VERSION)

define KERNEL_AW32_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_AW32_DL_SUBDIR)/$(KERNEL_AW32_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
