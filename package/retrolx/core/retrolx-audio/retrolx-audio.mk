################################################################################
#
# RETROLX AUDIO
#
################################################################################

RETROLX_AUDIO_VERSION = 5
RETROLX_AUDIO_LICENSE = GPL
RETROLX_AUDIO_DEPENDENCIES = alsa-lib
RETROLX_AUDIO_SOURCE=
RETROLX_AUDIO_DEPENDENCIES += alsa-plugins

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326_ANY),y)
ALSA_SUFFIX = "-rk3326"
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
ALSA_SUFFIX = "-rk3399"
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
ALSA_SUFFIX = "-s922x"
else
ALSA_SUFFIX =
endif

define RETROLX_AUDIO_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/python3.9 \
		$(TARGET_DIR)/usr/bin \
		$(TARGET_DIR)/usr/share/sounds \
		$(TARGET_DIR)/usr/share/retrolx/alsa \
		$(TARGET_DIR)/etc/init.d \
		$(TARGET_DIR)/etc/udev/rules.d
	# default alsa configurations
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-audio/alsa/asoundrc-* \
		$(TARGET_DIR)/usr/share/retrolx/alsa/
	# sample audio files
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-audio/*.wav $(TARGET_DIR)/usr/share/sounds
	# init script
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-audio/S01audio \
		$(TARGET_DIR)/etc/init.d/S01audio
	# udev script to unmute audio devices
	install -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-audio/90-alsa-setup.rules \
		$(TARGET_DIR)/etc/udev/rules.d/90-alsa-setup.rules
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-audio/soundconfig \
		$(TARGET_DIR)/usr/bin/soundconfig
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-audio/alsa/batocera-audio$(ALSA_SUFFIX) \
		$(TARGET_DIR)/usr/bin/batocera-audio
endef

$(eval $(generic-package))
