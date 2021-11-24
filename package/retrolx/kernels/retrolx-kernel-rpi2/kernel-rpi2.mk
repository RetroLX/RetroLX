################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_RPI2_VERSION_VALUE = 5.15.4
RETROLX_KERNEL_RPI2_ARCH = rpi2
RETROLX_KERNEL_RPI2_VERSION = $(RETROLX_KERNEL_RPI2_ARCH)-$(RETROLX_KERNEL_RPI2_VERSION_VALUE)
RETROLX_KERNEL_RPI2_SOURCE = kernel-$(RETROLX_KERNEL_RPI2_ARCH)-$(RETROLX_KERNEL_RPI2_VERSION_VALUE).tar.gz
RETROLX_KERNEL_RPI2_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_RPI2_VERSION)

define RETROLX_KERNEL_RPI2_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RPI2_DL_SUBDIR)/$(RETROLX_KERNEL_RPI2_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
