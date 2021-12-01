################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_I686_VERSION = 5.15.6
RETROLX_KERNEL_I686_ARCH = i686
RETROLX_KERNEL_I686_SOURCE = kernel-$(RETROLX_KERNEL_I686_ARCH)-$(RETROLX_KERNEL_I686_VERSION).tar.gz
RETROLX_KERNEL_I686_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_I686_ARCH)/$(RETROLX_KERNEL_I686_VERSION)

define RETROLX_KERNEL_I686_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_I686_DL_SUBDIR)/$(RETROLX_KERNEL_I686_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
