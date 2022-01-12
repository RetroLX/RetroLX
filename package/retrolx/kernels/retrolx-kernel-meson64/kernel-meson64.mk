################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_MESON64_VERSION = 5.15.14
RETROLX_KERNEL_MESON64_ARCH = meson64
RETROLX_KERNEL_MESON64_SOURCE = kernel-$(RETROLX_KERNEL_MESON64_ARCH)-$(RETROLX_KERNEL_MESON64_VERSION).tar.gz
RETROLX_KERNEL_MESON64_SITE = https://repository.retrolx.org/kernel/$(RETROLX_KERNEL_MESON64_ARCH)/$(RETROLX_KERNEL_MESON64_VERSION)

define RETROLX_KERNEL_MESON64_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/kernel-meson64
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_MESON64_DL_SUBDIR)/$(RETROLX_KERNEL_MESON64_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/kernel-meson64/
endef

$(eval $(generic-package))
