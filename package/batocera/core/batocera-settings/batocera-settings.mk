################################################################################
#
# batocera-settings
#
################################################################################

RETROLX_SETTINGS_VERSION = 0.0.5
RETROLX_SETTINGS_LICENSE = MIT
RETROLX_SETTINGS_SITE = $(call github,batocera-linux,mini_settings,$(RETROLX_SETTINGS_VERSION))
RETROLX_SETTINGS_CONF_OPTS = \
  -Ddefault_config_path=/userdata/system/batocera.conf \
  -Dget_exe_name=batocera-settings-get \
  -Dset_exe_name=batocera-settings-set

$(eval $(meson-package))
