################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_S922X_VERSION_VALUE = 5.15.5
RETROLX_KERNEL_S922X_ARCH = s922x
RETROLX_KERNEL_S922X_VERSION = $(RETROLX_KERNEL_S922X_ARCH)-$(RETROLX_KERNEL_S922X_VERSION_VALUE)
RETROLX_KERNEL_S922X_SOURCE = kernel-$(RETROLX_KERNEL_S922X_ARCH)-$(RETROLX_KERNEL_S922X_VERSION_VALUE).tar.gz
RETROLX_KERNEL_S922X_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_S922X_VERSION)

define RETROLX_KERNEL_S922X_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_S922X_DL_SUBDIR)/$(RETROLX_KERNEL_S922X_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
