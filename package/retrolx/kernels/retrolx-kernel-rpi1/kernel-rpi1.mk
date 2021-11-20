################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_RPI1_VERSION_VALUE = 5.15.1
RETROLX_KERNEL_RPI1_ARCH = rpi1
RETROLX_KERNEL_RPI1_VERSION = $(RETROLX_KERNEL_RPI1_ARCH)-$(RETROLX_KERNEL_RPI1_VERSION_VALUE)
RETROLX_KERNEL_RPI1_SOURCE = kernel-$(RETROLX_KERNEL_RPI1_ARCH)-$(RETROLX_KERNEL_RPI1_VERSION_VALUE).tar.gz
RETROLX_KERNEL_RPI1_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_RPI1_VERSION)

define RETROLX_KERNEL_RPI1_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RPI1_DL_SUBDIR)/$(RETROLX_KERNEL_RPI1_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
