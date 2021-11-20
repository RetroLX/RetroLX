################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_SUN50I_VERSION_VALUE = 5.15.2
RETROLX_KERNEL_SUN50I_ARCH = sun50i
RETROLX_KERNEL_SUN50I_VERSION = $(RETROLX_KERNEL_SUN50I_ARCH)-$(RETROLX_KERNEL_SUN50I_VERSION_VALUE)
RETROLX_KERNEL_SUN50I_SOURCE = kernel-$(RETROLX_KERNEL_SUN50I_ARCH)-$(RETROLX_KERNEL_SUN50I_VERSION_VALUE).tar.gz
RETROLX_KERNEL_SUN50I_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_SUN50I_VERSION)

define RETROLX_KERNEL_SUN50I_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_SUN50I_DL_SUBDIR)/$(RETROLX_KERNEL_SUN50I_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
