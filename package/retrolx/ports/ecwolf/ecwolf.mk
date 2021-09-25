################################################################################
#
# ECWOLF
#
################################################################################
# Version.: Commits on Feb 16, 2021
ECWOLF_VERSION = 3ce6e4d064b54eec72386fe949ec7be20746c16c
ECWOLF_SITE = https://bitbucket.org/ecwolf/ecwolf.git
ECWOLF_SITE_METHOD=git
ECWOLF_GIT_SUBMODULES=YES
ECWOLF_LICENSE = Non-commercial
ECWOLF_DEPENDENCIES = sdl2

ECWOLF_PKG_DIR = $(TARGET_DIR)/opt/retrolx/ecwolf
ECWOLF_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/ecwolf

# Install into package prefix
ECWOLF_INSTALL_TARGET_OPTS = DESTDIR="$(ECWOLF_PKG_DIR)$(ECWOLF_PKG_INSTALL_DIR)" install

ECWOLF_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release -DGPL=ON

ECWOLF_CONF_ENV += LDFLAGS="-lpthread -lvorbisfile -lopusfile -lFLAC -lmodplug -lfluidsynth"

define ECWOLF_INSTALL_TARGET_CMDS
	echo "no rootfs install, bundled as package"
endef

define ECWOLF_MAKEPKG
	# binaries
	$(INSTALL) -D -m 0755 $(@D)/ecwolf $(ECWOLF_PKG_DIR)$(ECWOLF_PKG_INSTALL_DIR)
	cp -a $(@D)/ecwolf.pk3 $(ECWOLF_PKG_DIR)$(ECWOLF_PKG_INSTALL_DIR)/

	# evmap config
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/ecwolf/port.ecwolf.keys $(ECWOLF_PKG_DIR)$(ECWOLF_PKG_INSTALL_DIR)

	# configgen
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/ecwolf/*.py $(ECWOLF_PKG_DIR)$(ECWOLF_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(ECWOLF_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/ecwolf/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

ECWOLF_POST_INSTALL_TARGET_HOOKS = ECWOLF_MAKEPKG

$(eval $(cmake-package))
