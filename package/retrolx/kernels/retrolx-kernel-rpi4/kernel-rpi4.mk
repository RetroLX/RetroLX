################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_RPI4_VERSION = 5.15.5
RETROLX_KERNEL_RPI4_ARCH = rpi4
RETROLX_KERNEL_RPI4_SOURCE = kernel-$(RETROLX_KERNEL_RPI4_ARCH)-$(RETROLX_KERNEL_RPI4_VERSION).tar.gz
RETROLX_KERNEL_RPI4_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_RPI4_ARCH)/$(RETROLX_KERNEL_RPI4_VERSION)

define RETROLX_KERNEL_RPI4_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RPI4_DL_SUBDIR)/$(RETROLX_KERNEL_RPI4_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
