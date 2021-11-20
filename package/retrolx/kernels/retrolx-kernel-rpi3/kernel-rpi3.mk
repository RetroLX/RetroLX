################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_RPI3_VERSION_VALUE = 5.15.1
RETROLX_KERNEL_RPI3_ARCH = rpi3
RETROLX_KERNEL_RPI3_VERSION = $(RETROLX_KERNEL_RPI3_ARCH)-$(RETROLX_KERNEL_RPI3_VERSION_VALUE)
RETROLX_KERNEL_RPI3_SOURCE = kernel-$(RETROLX_KERNEL_RPI3_ARCH)-$(RETROLX_KERNEL_RPI3_VERSION_VALUE).tar.gz
RETROLX_KERNEL_RPI3_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_RPI3_VERSION)

define RETROLX_KERNEL_RPI3_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RPI3_DL_SUBDIR)/$(RETROLX_KERNEL_RPI3_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
