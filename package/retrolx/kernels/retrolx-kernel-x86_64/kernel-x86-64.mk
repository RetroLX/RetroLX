################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_X86_64_VERSION = 5.15.39-1
RETROLX_KERNEL_X86_64_ARCH = x86_64
RETROLX_KERNEL_X86_64_SOURCE = kernel-$(RETROLX_KERNEL_X86_64_ARCH)-$(RETROLX_KERNEL_X86_64_VERSION).tar.gz
RETROLX_KERNEL_X86_64_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_X86_64_ARCH)/$(RETROLX_KERNEL_X86_64_VERSION)

define RETROLX_KERNEL_X86_64_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_X86_64_DL_SUBDIR)/$(RETROLX_KERNEL_X86_64_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
