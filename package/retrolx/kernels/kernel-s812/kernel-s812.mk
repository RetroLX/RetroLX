################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
KERNEL_S812_VERSION_VALUE = 5.15.2
KERNEL_S812_ARCH = s812
KERNEL_S812_VERSION = $(KERNEL_S812_ARCH)-$(KERNEL_S812_VERSION_VALUE)
KERNEL_S812_SOURCE = kernel-$(KERNEL_S812_ARCH)-$(KERNEL_S812_VERSION_VALUE).tar.gz
KERNEL_S812_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_S812_VERSION)

define KERNEL_S812_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_S812_DL_SUBDIR)/$(KERNEL_S812_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
