################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_PS4_VERSION = 5.15.14
RETROLX_KERNEL_PS4_ARCH = ps4
RETROLX_KERNEL_PS4_SOURCE = kernel-$(RETROLX_KERNEL_PS4_ARCH)-$(RETROLX_KERNEL_PS4_VERSION).tar.gz
RETROLX_KERNEL_PS4_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_PS4_ARCH)/$(RETROLX_KERNEL_PS4_VERSION)

define RETROLX_KERNEL_PS4_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_PS4_DL_SUBDIR)/$(RETROLX_KERNEL_PS4_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
