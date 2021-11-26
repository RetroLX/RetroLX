################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNEL_MESON64_VERSION_VALUE = 5.15.5
RETROLX_KERNEL_MESON64_ARCH = meson64
RETROLX_KERNEL_MESON64_VERSION = $(RETROLX_KERNEL_MESON64_ARCH)-$(RETROLX_KERNEL_MESON64_VERSION_VALUE)
RETROLX_KERNEL_MESON64_SOURCE = kernel-$(RETROLX_KERNEL_MESON64_ARCH)-$(RETROLX_KERNEL_MESON64_VERSION_VALUE).tar.gz
RETROLX_KERNEL_MESON64_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_MESON64_VERSION)

define RETROLX_KERNEL_MESON64_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_MESON64_DL_SUBDIR)/$(RETROLX_KERNEL_MESON64_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
