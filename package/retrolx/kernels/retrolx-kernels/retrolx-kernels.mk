################################################################################
#
# RetroLX kernel package
#
################################################################################

# Mainline kernels
RETROLX_KERNELS_VERSION_VALUE = 5.10.53

# Raspberry pi kernels
ifeq ($(BATOCERA_SYSTEM_ARCH),rpi1)
RETROLX_KERNELS_VERSION_VALUE = 5.10.52
else ifeq ($(BATOCERA_SYSTEM_ARCH),rpi2)
RETROLX_KERNELS_VERSION_VALUE = 5.10.52
else ifeq ($(BATOCERA_SYSTEM_ARCH),rpi3)
RETROLX_KERNELS_VERSION_VALUE = 5.10.52
else ifeq ($(BATOCERA_SYSTEM_ARCH),rpi4)
RETROLX_KERNELS_VERSION_VALUE = 5.10.52
endif

# Custom kernels
ifeq ($(BATOCERA_SYSTEM_ARCH),s812)
RETROLX_KERNELS_VERSION_VALUE = 20210725
endif
ifeq ($(BATOCERA_SYSTEM_ARCH),h616)
RETROLX_KERNELS_VERSION_VALUE = 20210725
endif

RETROLX_KERNELS_VERSION = $(BATOCERA_SYSTEM_ARCH)-$(RETROLX_KERNELS_VERSION_VALUE)
RETROLX_KERNELS_SOURCE = kernel-$(BATOCERA_SYSTEM_ARCH)-$(RETROLX_KERNELS_VERSION_VALUE).tar.gz
RETROLX_KERNELS_SITE = https://github.com/RetroLX/kernel/releases/download/$(RETROLX_KERNELS_VERSION)

define RETROLX_KERNELS_INSTALL_TARGET_CMDS
	cd $(@D) && tar xzvf $(DL_DIR)/$(RETROLX_KERNELS_DL_SUBDIR)/$(RETROLX_KERNELS_SOURCE) && cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
