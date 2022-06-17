################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_S905GEN3_VERSION = 5.15.41-1
RETROLX_KERNEL_S905GEN3_ARCH = s905gen3
RETROLX_KERNEL_S905GEN3_SOURCE = kernel-$(RETROLX_KERNEL_S905GEN3_ARCH)-$(RETROLX_KERNEL_S905GEN3_VERSION).tar.gz
RETROLX_KERNEL_S905GEN3_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_S905GEN3_ARCH)/$(RETROLX_KERNEL_S905GEN3_VERSION)

define RETROLX_KERNEL_S905GEN3_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/kernel-s905gen3
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_S905GEN3_DL_SUBDIR)/$(RETROLX_KERNEL_S905GEN3_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/kernel-s905gen3/
endef

$(eval $(generic-package))
