################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
KERNEL_X86_64_VERSION_VALUE = 5.15.2
KERNEL_X86_64_ARCH = x86_64
KERNEL_X86_64_VERSION = $(KERNEL_X86_64_ARCH)-$(KERNEL_X86_64_VERSION_VALUE)
KERNEL_X86_64_SOURCE = kernel-$(KERNEL_X86_64_ARCH)-$(KERNEL_X86_64_VERSION_VALUE).tar.gz
KERNEL_X86_64_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_X86_64_VERSION)

define KERNEL_X86_64_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_X86_64_DL_SUBDIR)/$(KERNEL_X86_64_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
