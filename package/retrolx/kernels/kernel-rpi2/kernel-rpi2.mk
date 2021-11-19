################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
KERNEL_RPI2_VERSION_VALUE = 5.15.1
KERNEL_RPI2_ARCH = rpi2
KERNEL_RPI2_VERSION = $(KERNEL_RPI2_ARCH)-$(KERNEL_RPI2_VERSION_VALUE)
KERNEL_RPI2_SOURCE = kernel-$(KERNEL_RPI2_ARCH)-$(KERNEL_RPI2_VERSION_VALUE).tar.gz
KERNEL_RPI2_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_RPI2_VERSION)

define KERNEL_RPI2_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_RPI2_DL_SUBDIR)/$(KERNEL_RPI2_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
