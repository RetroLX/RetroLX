################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_S812_VERSION = 5.15.28-1
RETROLX_KERNEL_S812_ARCH = s812
RETROLX_KERNEL_S812_SOURCE = kernel-$(RETROLX_KERNEL_S812_ARCH)-$(RETROLX_KERNEL_S812_VERSION).tar.gz
RETROLX_KERNEL_S812_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_S812_ARCH)/$(RETROLX_KERNEL_S812_VERSION)

define RETROLX_KERNEL_S812_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_S812_DL_SUBDIR)/$(RETROLX_KERNEL_S812_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
