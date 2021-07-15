################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNEL_VERSION_VALUE = 5.10.50

# Custom kernel
ifeq ($(BATOCERA_SYSTEM_ARCH),s812)
RETROLX_KERNEL_VERSION_VALUE = 20210715
endif
ifeq ($(BATOCERA_SYSTEM_ARCH),h616)
RETROLX_KERNEL_VERSION_VALUE = 20210715
endif

RETROLX_KERNEL_VERSION = $(BATOCERA_SYSTEM_ARCH)-$(RETROLX_KERNEL_VERSION_VALUE)
RETROLX_KERNEL_SOURCE = kernel.tar.gz
RETROLX_KERNEL_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNEL_VERSION)

define RETROLX_KERNEL_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNEL_DL_SUBDIR)/$(RETROLX_KERNEL_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
