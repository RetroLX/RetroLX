################################################################################
#
# RetroLX kernel package
#
################################################################################

# Custom kernel
RETROLX_KERNEL_RK3128_VERSION = 5.19-1
RETROLX_KERNEL_RK3128_ARCH = rk3128
RETROLX_KERNEL_RK3128_SOURCE = kernel-$(RETROLX_KERNEL_RK3128_ARCH)-$(RETROLX_KERNEL_RK3128_VERSION).tar.gz
RETROLX_KERNEL_RK3128_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_RK3128_ARCH)/$(RETROLX_KERNEL_RK3128_VERSION)

define RETROLX_KERNEL_RK3128_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/kernel-rk3128
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_RK3128_DL_SUBDIR)/$(RETROLX_KERNEL_RK3128_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/kernel-rk3128/
endef

$(eval $(generic-package))
