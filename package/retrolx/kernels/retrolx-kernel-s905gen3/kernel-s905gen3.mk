################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_S905GEN3_VERSION_VALUE = 5.15.5
RETROLX_KERNEL_S905GEN3_ARCH = s905gen3
RETROLX_KERNEL_S905GEN3_VERSION = $(RETROLX_KERNEL_S905GEN3_ARCH)-$(RETROLX_KERNEL_S905GEN3_VERSION_VALUE)
RETROLX_KERNEL_S905GEN3_SOURCE = kernel-$(RETROLX_KERNEL_S905GEN3_ARCH)-$(RETROLX_KERNEL_S905GEN3_VERSION_VALUE).tar.gz
RETROLX_KERNEL_S905GEN3_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_S905GEN3_VERSION)

define RETROLX_KERNEL_S905GEN3_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/kernel-s905gen3
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_S905GEN3_DL_SUBDIR)/$(RETROLX_KERNEL_S905GEN3_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/kernel-s905gen3/
endef

$(eval $(generic-package))
