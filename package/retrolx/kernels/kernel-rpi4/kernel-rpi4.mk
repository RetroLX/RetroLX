################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
KERNEL_RPI4_VERSION_VALUE = 5.15.1
KERNEL_RPI4_ARCH = rpi4
KERNEL_RPI4_VERSION = $(KERNEL_RPI4_ARCH)-$(KERNEL_RPI4_VERSION_VALUE)
KERNEL_RPI4_SOURCE = kernel-$(KERNEL_RPI4_ARCH)-$(KERNEL_RPI4_VERSION_VALUE).tar.gz
KERNEL_RPI4_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_RPI4_VERSION)

define KERNEL_RPI4_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_RPI4_DL_SUBDIR)/$(KERNEL_RPI4_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
