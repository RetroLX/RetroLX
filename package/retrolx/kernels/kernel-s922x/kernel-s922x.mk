################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_S922X_VERSION_VALUE = 5.15.2
KERNEL_S922X_ARCH = s922x
KERNEL_S922X_VERSION = $(KERNEL_S922X_ARCH)-$(KERNEL_S922X_VERSION_VALUE)
KERNEL_S922X_SOURCE = kernel-$(KERNEL_S922X_ARCH)-$(KERNEL_S922X_VERSION_VALUE).tar.gz
KERNEL_S922X_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_S922X_VERSION)

define KERNEL_S922X_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_S922X_DL_SUBDIR)/$(KERNEL_S922X_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
