################################################################################
#
# RetroLX splash
#
################################################################################
RETROLX_SPLASH_VERSION = 1
RETROLX_SPLASH_SOURCE=
RETROLX_SYSTEM_GIT_VERSION = $(shell git log -n 1 --pretty=format:"%h")

ifeq ($(findstring dev,$(RETROLX_SYSTEM_VERSION)),dev)
	RETROLX_SPLASH_TGVERSION=$(RETROLX_SYSTEM_VERSION)-$(RETROLX_SYSTEM_GIT_VERSION) $(RETROLX_SYSTEM_DATE_TIME)
else
	RETROLX_SPLASH_TGVERSION=$(RETROLX_SYSTEM_VERSION) $(RETROLX_SYSTEM_DATE)
endif

RETROLX_SPLASH_PLAYER_OPTIONS=

ifeq ($(BR2_PACKAGE_RETROLX_SPLASH_OMXPLAYER),y)
	RETROLX_SPLASH_SCRIPT=S03splash-omx
	RETROLX_SPLASH_MEDIA=video
else ifeq ($(BR2_PACKAGE_RETROLX_SPLASH_FFPLAY),y)
	RETROLX_SPLASH_SCRIPT=S03splash-ffplay
	RETROLX_SPLASH_MEDIA=video
else ifeq ($(BR2_PACKAGE_RETROLX_SPLASH_MPV),y)
	RETROLX_SPLASH_SCRIPT=S03splash-mpv.template
	RETROLX_SPLASH_MEDIA=video
else
	RETROLX_SPLASH_SCRIPT=S03splash-image
	RETROLX_SPLASH_MEDIA=image
endif

ifeq ($(BR2_PACKAGE_RETROLX_SPLASH_MPV)$(BR2_x86_64),yy)
	RETROLX_SPLASH_PLAYER_OPTIONS=--vo=drm
endif

RETROLX_SPLASH_POST_INSTALL_TARGET_HOOKS += RETROLX_SPLASH_INSTALL_SCRIPT

ifeq ($(RETROLX_SPLASH_MEDIA),image)
	RETROLX_SPLASH_POST_INSTALL_TARGET_HOOKS += RETROLX_SPLASH_INSTALL_IMAGE
endif

ifeq ($(RETROLX_SPLASH_MEDIA),video)
	RETROLX_SPLASH_POST_INSTALL_TARGET_HOOKS += RETROLX_SPLASH_INSTALL_VIDEO
endif

define RETROLX_SPLASH_INSTALL_SCRIPT
	mkdir -p $(TARGET_DIR)/etc/init.d
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-splash/S29splashscreencontrol	  $(TARGET_DIR)/etc/init.d/
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-splash/$(RETROLX_SPLASH_SCRIPT) $(TARGET_DIR)/etc/init.d/S03splash
	sed -i -e s+"%PLAYER_OPTIONS%"+"$(RETROLX_SPLASH_PLAYER_OPTIONS)"+g $(TARGET_DIR)/etc/init.d/S03splash
endef

define RETROLX_SPLASH_INSTALL_VIDEO
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/splash
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-splash/splash.mp4 $(TARGET_DIR)/usr/share/retrolx/splash
	echo -e "1\n00:00:00,000 --> 00:00:02,000\n$(RETROLX_SPLASH_TGVERSION)" > "${TARGET_DIR}/usr/share/retrolx/splash/splash.srt"
endef

define RETROLX_SPLASH_INSTALL_IMAGE
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/splash
	convert "$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-splash/logo.png" -fill white -pointsize 30 -annotate +50+1020 "$(RETROLX_SPLASH_TGVERSION)" "${TARGET_DIR}/usr/share/retrolx/splash/logo-version.png"
endef

$(eval $(generic-package))
