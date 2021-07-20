################################################################################
#
# BATOCERA-ES-SYSTEM
#
################################################################################

RETROLX_ES_SYSTEM_DEPENDENCIES = host-python3 host-python-pyyaml batocera-configgen
RETROLX_ES_SYSTEM_SOURCE=
RETROLX_ES_SYSTEM_VERSION=1.03

define RETROLX_ES_SYSTEM_BUILD_CMDS
	$(HOST_DIR)/bin/python \
		$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/frontends/emulationstation/retrolx-es-system/retrolx-es-system.py \
		$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/frontends/emulationstation/retrolx-es-system/es_systems.yml       \
		$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/frontends/emulationstation/retrolx-es-system/es_features.yml      \
		$(CONFIG_DIR)/.config \
		$(@D)/es_systems.cfg \
		$(@D)/es_features.cfg \
		$(STAGING_DIR)/usr/share/batocera/configgen/configgen-defaults.yml \
		$(STAGING_DIR)/usr/share/batocera/configgen/configgen-defaults-arch.yml \
		$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/frontends/emulationstation/retrolx-es-system/roms \
		$(@D)/roms $(BATOCERA_SYSTEM_ARCH)
endef

define RETROLX_ES_SYSTEM_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)/usr/share/batocera/datainit

	# Install to target to be able to generate es files dynamically
	$(INSTALL) -m 0755 -D $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/frontends/emulationstation/retrolx-es-system/retrolx-rebuild-es-systems.sh \
	                      $(TARGET_DIR)/usr/bin/retrolx-rebuild-es-systems.sh
	$(INSTALL) -m 0755 -D $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/frontends/emulationstation/retrolx-es-system/retrolx-es-system.py \
	                      $(TARGET_DIR)/usr/share/emulationstation/retrolx-es-system.py
	$(INSTALL) -m 0644 -D $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/frontends/emulationstation/retrolx-es-system/es_systems.yml \
	                      $(TARGET_DIR)/usr/share/emulationstation/es_systems.yml
	$(INSTALL) -m 0644 -D $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/frontends/emulationstation/retrolx-es-system/es_features.yml \
	                      $(TARGET_DIR)/usr/share/emulationstation/es_features.yml
	$(INSTALL) -m 0644 -D $(STAGING_DIR)/usr/share/batocera/configgen/configgen-defaults.yml \
	                      $(TARGET_DIR)/usr/share/emulationstation/configgen-defaults.yml
	$(INSTALL) -m 0644 -D $(STAGING_DIR)/usr/share/batocera/configgen/configgen-defaults-arch.yml \
	                      $(TARGET_DIR)/usr/share/emulationstation/configgen-defaults-arch.yml

	# Prebuilt stuff, to be removed
	$(INSTALL) -m 0644 -D $(@D)/es_systems.cfg $(TARGET_DIR)/usr/share/emulationstation/es_systems.cfg
	$(INSTALL) -m 0644 -D $(@D)/es_features.cfg $(TARGET_DIR)/usr/share/emulationstation/es_features.cfg
        mkdir -p $(@D)/roms # in case there is no rom
	cp -pr $(@D)/roms $(TARGET_DIR)/usr/share/batocera/datainit/
endef

$(eval $(generic-package))
