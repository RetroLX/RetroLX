################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_I686_VERSION_VALUE = 5.15.2
KERNEL_I686_ARCH = i686
KERNEL_I686_VERSION = $(KERNEL_I686_ARCH)-$(KERNEL_I686_VERSION_VALUE)
KERNEL_I686_SOURCE = kernel-$(KERNEL_I686_ARCH)-$(KERNEL_I686_VERSION_VALUE).tar.gz
KERNEL_I686_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_I686_VERSION)

define KERNEL_I686_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_I686_DL_SUBDIR)/$(KERNEL_I686_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
