################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_RPI3_VERSION = 5.15.5
RETROLX_KERNEL_RPI3_ARCH = rpi3
RETROLX_KERNEL_RPI3_SOURCE = kernel-$(RETROLX_KERNEL_RPI3_ARCH)-$(RETROLX_KERNEL_RPI3_VERSION).tar.gz
RETROLX_KERNEL_RPI3_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_RPI3_ARCH)/$(RETROLX_KERNEL_RPI3_VERSION)

define RETROLX_KERNEL_RPI3_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RPI3_DL_SUBDIR)/$(RETROLX_KERNEL_RPI3_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
