################################################################################
#
# RetroLX kernel package
#
################################################################################

# Custom kernel
KERNEL_RK356X_VERSION_VALUE = 20211117
KERNEL_RK356X_ARCH = rk356x
KERNEL_RK356X_VERSION = $(KERNEL_RK356X_ARCH)-$(KERNEL_RK356X_VERSION_VALUE)
KERNEL_RK356X_SOURCE = kernel-$(KERNEL_RK356X_ARCH)-$(KERNEL_RK356X_VERSION_VALUE).tar.gz
KERNEL_RK356X_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_RK356X_VERSION)

define KERNEL_RK356X_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_RK356X_DL_SUBDIR)/$(KERNEL_RK356X_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
