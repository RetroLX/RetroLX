################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_SUN50I_VERSION_VALUE = 5.15.2
KERNEL_SUN50I_ARCH = sun50i
KERNEL_SUN50I_VERSION = $(KERNEL_SUN50I_ARCH)-$(KERNEL_SUN50I_VERSION_VALUE)
KERNEL_SUN50I_SOURCE = kernel-$(KERNEL_SUN50I_ARCH)-$(KERNEL_SUN50I_VERSION_VALUE).tar.gz
KERNEL_SUN50I_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_SUN50I_VERSION)

define KERNEL_SUN50I_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_SUN50I_DL_SUBDIR)/$(KERNEL_SUN50I_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
