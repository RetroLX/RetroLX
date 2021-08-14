################################################################################
#
# Batocera desktop applications
#
################################################################################
RETROLX_DESKTOPAPPS_VERSION = 1.0
RETROLX_DESKTOPAPPS_SOURCE=

RETROLX_DESKTOPAPPS_SCRIPTS = filemanagerlauncher
RETROLX_DESKTOPAPPS_APPS  = xterm.desktop
RETROLX_DESKTOPAPPS_ICONS =

# pcsx2
ifneq ($(BR2_PACKAGE_PCSX2_X86)$(BR2_PACKAGE_PCSX2)$(BR2_PACKAGE_PCSX2_AVX2),)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-pcsx2
  RETROLX_DESKTOPAPPS_APPS    += pcsx2-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += pcsx2.png
endif

# dolphin
ifeq ($(BR2_PACKAGE_DOLPHIN_EMU),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-dolphin
  RETROLX_DESKTOPAPPS_APPS    += dolphin-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += dolphin.png
endif

# duckstation
ifeq ($(BR2_PACKAGE_DUCKSTATION),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-duckstation
  RETROLX_DESKTOPAPPS_APPS    += duckstation-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += duckstation.png
endif

# retroarch
ifeq ($(BR2_PACKAGE_RETROARCH),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-retroarch
  RETROLX_DESKTOPAPPS_APPS    += retroarch-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += retroarch.png
endif

# ppsspp
ifeq ($(BR2_PACKAGE_PPSSPP),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-ppsspp
  RETROLX_DESKTOPAPPS_APPS    += ppsspp-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += ppsspp.png
endif

# flycast
ifeq ($(BR2_PACKAGE_FLYCAST),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-flycast
  RETROLX_DESKTOPAPPS_APPS    += flycast-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += flycast.png
endif

# scummvm
ifeq ($(BR2_PACKAGE_SCUMMVM),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-scummvm
  RETROLX_DESKTOPAPPS_APPS    += scummvm-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += scummvm.png
endif

# citra
ifeq ($(BR2_PACKAGE_CITRA),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-citra
  RETROLX_DESKTOPAPPS_APPS    += citra-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += citra.png
endif

# rpcs3
ifeq ($(BR2_PACKAGE_RPCS3),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-rpcs3
  RETROLX_DESKTOPAPPS_APPS    += rpcs3-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += rpcs3.png
endif

# cemu
ifeq ($(BR2_PACKAGE_CEMU),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-cemu
  RETROLX_DESKTOPAPPS_APPS    += cemu-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += cemu.png
endif

# fpinball
ifeq ($(BR2_PACKAGE_FPINBALL),y)
  RETROLX_DESKTOPAPPS_SCRIPTS += batocera-config-fpinball
  RETROLX_DESKTOPAPPS_APPS    += fpinball-config.desktop
  RETROLX_DESKTOPAPPS_ICONS   += fpinball.png
endif

define RETROLX_DESKTOPAPPS_INSTALL_TARGET_CMDS
	# scripts
	mkdir -p $(TARGET_DIR)/usr/bin
	$(foreach f,$(RETROLX_DESKTOPAPPS_SCRIPTS), cp $(BR2_EXTERNAL_RETROLX_PATH)/package/batocera/core/batocera-desktopapps/scripts/$(f) $(TARGET_DIR)/usr/bin/$(f)$(sep))

	# apps
	mkdir -p $(TARGET_DIR)/usr/share/applications
	$(foreach f,$(RETROLX_DESKTOPAPPS_APPS), cp $(BR2_EXTERNAL_RETROLX_PATH)/package/batocera/core/batocera-desktopapps/apps/$(f) $(TARGET_DIR)/usr/share/applications/$(f)$(sep))

	# icons
	mkdir -p $(TARGET_DIR)/usr/share/icons/batocera
	$(foreach f,$(RETROLX_DESKTOPAPPS_ICONS), cp $(BR2_EXTERNAL_RETROLX_PATH)/package/batocera/core/batocera-desktopapps/icons/$(f) $(TARGET_DIR)/usr/share/icons/batocera/$(f)$(sep))

	# menu
	mkdir -p $(TARGET_DIR)/etc/xdg/menus
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/batocera/core/batocera-desktopapps/menu/batocera-applications.menu $(TARGET_DIR)/etc/xdg/menus/batocera-applications.menu
endef

$(eval $(generic-package))
