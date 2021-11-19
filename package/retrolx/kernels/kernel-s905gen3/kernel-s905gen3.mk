################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
KERNEL_S905GEN3_VERSION_VALUE = 5.15.2
KERNEL_S905GEN3_ARCH = s905gen3
KERNEL_S905GEN3_VERSION = $(KERNEL_S905GEN3_ARCH)-$(KERNEL_S905GEN3_VERSION_VALUE)
KERNEL_S905GEN3_SOURCE = kernel-$(KERNEL_S905GEN3_ARCH)-$(KERNEL_S905GEN3_VERSION_VALUE).tar.gz
KERNEL_S905GEN3_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_S905GEN3_VERSION)

define KERNEL_S905GEN3_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_S905GEN3_DL_SUBDIR)/$(KERNEL_S905GEN3_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
