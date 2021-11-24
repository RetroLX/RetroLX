################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_X86_64_VERSION_VALUE = 5.15.4
RETROLX_KERNEL_X86_64_ARCH = x86_64
RETROLX_KERNEL_X86_64_VERSION = $(RETROLX_KERNEL_X86_64_ARCH)-$(RETROLX_KERNEL_X86_64_VERSION_VALUE)
RETROLX_KERNEL_X86_64_SOURCE = kernel-$(RETROLX_KERNEL_X86_64_ARCH)-$(RETROLX_KERNEL_X86_64_VERSION_VALUE).tar.gz
RETROLX_KERNEL_X86_64_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_X86_64_VERSION)

define RETROLX_KERNEL_X86_64_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_X86_64_DL_SUBDIR)/$(RETROLX_KERNEL_X86_64_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
