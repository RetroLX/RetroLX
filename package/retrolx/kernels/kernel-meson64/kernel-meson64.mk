################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
KERNEL_MESON64_VERSION_VALUE = 5.15.2
KERNEL_MESON64_ARCH = meson64
KERNEL_MESON64_VERSION = $(KERNEL_MESON64_ARCH)-$(KERNEL_MESON64_VERSION_VALUE)
KERNEL_MESON64_SOURCE = kernel-$(KERNEL_MESON64_ARCH)-$(KERNEL_MESON64_VERSION_VALUE).tar.gz
KERNEL_MESON64_SITE = https://github.com/RetroLX/kernel/releases/download/$(KERNEL_MESON64_VERSION)

define KERNEL_MESON64_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(KERNEL_MESON64_DL_SUBDIR)/$(KERNEL_MESON64_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
