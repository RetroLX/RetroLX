################################################################################
#
# RetroLX kernel package
#
################################################################################

# Custom kernel
RETROLX_KERNEL_RK356X_VERSION = 5.16.9-1
RETROLX_KERNEL_RK356X_ARCH = rk356x
RETROLX_KERNEL_RK356X_SOURCE = kernel-$(RETROLX_KERNEL_RK356X_ARCH)-$(RETROLX_KERNEL_RK356X_VERSION).tar.gz
RETROLX_KERNEL_RK356X_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_RK356X_ARCH)/$(RETROLX_KERNEL_RK356X_VERSION)

define RETROLX_KERNEL_RK356X_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/kernel-rk356x
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RK356X_DL_SUBDIR)/$(RETROLX_KERNEL_RK356X_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/kernel-rk356x/
endef

$(eval $(generic-package))
