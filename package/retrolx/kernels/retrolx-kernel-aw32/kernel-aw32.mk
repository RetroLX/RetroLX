################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_AW32_VERSION_VALUE = 5.15.4
RETROLX_KERNEL_AW32_ARCH = aw32
RETROLX_KERNEL_AW32_VERSION = $(RETROLX_KERNEL_AW32_ARCH)-$(RETROLX_KERNEL_AW32_VERSION_VALUE)
RETROLX_KERNEL_AW32_SOURCE = kernel-$(RETROLX_KERNEL_AW32_ARCH)-$(RETROLX_KERNEL_AW32_VERSION_VALUE).tar.gz
RETROLX_KERNEL_AW32_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_AW32_VERSION)

define RETROLX_KERNEL_AW32_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_AW32_DL_SUBDIR)/$(RETROLX_KERNEL_AW32_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
