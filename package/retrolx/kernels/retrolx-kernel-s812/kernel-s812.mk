################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_S812_VERSION_VALUE = 5.15.5
RETROLX_KERNEL_S812_ARCH = s812
RETROLX_KERNEL_S812_VERSION = $(RETROLX_KERNEL_S812_ARCH)-$(RETROLX_KERNEL_S812_VERSION_VALUE)
RETROLX_KERNEL_S812_SOURCE = kernel-$(RETROLX_KERNEL_S812_ARCH)-$(RETROLX_KERNEL_S812_VERSION_VALUE).tar.gz
RETROLX_KERNEL_S812_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_S812_VERSION)

define RETROLX_KERNEL_S812_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_S812_DL_SUBDIR)/$(RETROLX_KERNEL_S812_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
