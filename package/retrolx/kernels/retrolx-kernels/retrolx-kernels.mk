################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernel
RETROLX_KERNELS_VERSION_VALUE = 5.10.50

# Custom kernel
ifeq ($(BATOCERA_SYSTEM_ARCH),s812)
RETROLX_KERNELS_VERSION_VALUE = 20210715
endif
ifeq ($(BATOCERA_SYSTEM_ARCH),h616)
RETROLX_KERNELS_VERSION_VALUE = 20210715
endif

RETROLX_KERNELS_VERSION = $(BATOCERA_SYSTEM_ARCH)-$(RETROLX_KERNELS_VERSION_VALUE)
RETROLX_KERNELS_SOURCE = kernel.tar.gz
RETROLX_KERNELS_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNELS_VERSION)

define RETROLX_KERNELS_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNELS_DL_SUBDIR)/$(RETROLX_KERNELS_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
