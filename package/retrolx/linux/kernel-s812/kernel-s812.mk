################################################################################
#
# RetroLX meson8 (Amlogic S812) kernel package
#
################################################################################
KERNEL_S812_VERSION = main
KERNEL_S812_SITE = https://github.com/RetroLX/kernel-s812.git
KERNEL_S812_SITE_METHOD = git

define KERNEL_S812_INSTALL_TARGET_CMDS
	cp $(@D)/*      $(BINARIES_DIR)/
endef

$(eval $(generic-package))
