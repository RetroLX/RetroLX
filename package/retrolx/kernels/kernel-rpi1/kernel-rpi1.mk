################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
KERNEL_RPI1_VERSION_VALUE = 5.15.1
KERNEL_RPI1_ARCH = rpi1
KERNEL_RPI1_VERSION = $(KERNEL_RPI1_ARCH)-$(KERNEL_RPI1_VERSION_VALUE)
KERNEL_RPI1_SOURCE = kernel-$(KERNEL_RPI1_ARCH)-$(KERNEL_RPI1_VERSION_VALUE).tar.gz
KERNEL_RPI1_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_RPI1_VERSION)

define KERNEL_RPI1_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_RPI1_DL_SUBDIR)/$(KERNEL_RPI1_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
