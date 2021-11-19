################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
KERNEL_RPI3_VERSION_VALUE = 5.15.1
KERNEL_RPI3_ARCH = rpi3
KERNEL_RPI3_VERSION = $(KERNEL_RPI3_ARCH)-$(KERNEL_RPI3_VERSION_VALUE)
KERNEL_RPI3_SOURCE = kernel-$(KERNEL_RPI3_ARCH)-$(KERNEL_RPI3_VERSION_VALUE).tar.gz
KERNEL_RPI3_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_RPI3_VERSION)

define KERNEL_RPI3_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_RPI3_DL_SUBDIR)/$(KERNEL_RPI3_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
