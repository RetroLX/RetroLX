################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_I686_VERSION_VALUE = 5.15.5
RETROLX_KERNEL_I686_ARCH = i686
RETROLX_KERNEL_I686_VERSION = $(RETROLX_KERNEL_I686_ARCH)-$(RETROLX_KERNEL_I686_VERSION_VALUE)
RETROLX_KERNEL_I686_SOURCE = kernel-$(RETROLX_KERNEL_I686_ARCH)-$(RETROLX_KERNEL_I686_VERSION_VALUE).tar.gz
RETROLX_KERNEL_I686_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_I686_VERSION)

define RETROLX_KERNEL_I686_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_I686_DL_SUBDIR)/$(RETROLX_KERNEL_I686_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
