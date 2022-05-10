################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_RPI1_VERSION = 5.15.36-1
RETROLX_KERNEL_RPI1_ARCH = rpi1
RETROLX_KERNEL_RPI1_SOURCE = kernel-$(RETROLX_KERNEL_RPI1_ARCH)-$(RETROLX_KERNEL_RPI1_VERSION).tar.gz
RETROLX_KERNEL_RPI1_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_RPI1_ARCH)/$(RETROLX_KERNEL_RPI1_VERSION)

define RETROLX_KERNEL_RPI1_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RPI1_DL_SUBDIR)/$(RETROLX_KERNEL_RPI1_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
