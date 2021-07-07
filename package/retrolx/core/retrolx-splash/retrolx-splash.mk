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
else ifeq ($(BR2_PACKAGE_RETROLX_SPLASH_ROTATE_IMAGE),y)
    RETROLX_SPLASH_SCRIPT=S03splash-image
    ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326_ANY),y)
        RETROLX_SPLASH_MEDIA=rotate-rk3326-image
    else
        RETROLX_SPLASH_MEDIA=rotate-image
    endif
else
	RETROLX_SPLASH_SCRIPT=S03splash-image
	RETROLX_SPLASH_MEDIA=image
endif

ifeq ($(BR2_PACKAGE_RETROLX_SPLASH_MPV)$(BR2_PACKAGE_BATOCERA_TARGET_X86_64),yy)
	RETROLX_SPLASH_PLAYER_OPTIONS=--vo=drm
endif

RETROLX_SPLASH_POST_INSTALL_TARGET_HOOKS += RETROLX_SPLASH_INSTALL_SCRIPT

ifeq ($(RETROLX_SPLASH_MEDIA),image)
	RETROLX_SPLASH_POST_INSTALL_TARGET_HOOKS += RETROLX_SPLASH_INSTALL_IMAGE
endif

ifeq ($(RETROLX_SPLASH_MEDIA),rotate-rk3326-image)
	RETROLX_SPLASH_POST_INSTALL_TARGET_HOOKS += RETROLX_SPLASH_INSTALL_ROTATE_RK3326_IMAGE
endif

ifeq ($(RETROLX_SPLASH_MEDIA),rotate-image)
	RETROLX_SPLASH_POST_INSTALL_TARGET_HOOKS += RETROLX_SPLASH_INSTALL_ROTATE_IMAGE
endif

ifeq ($(RETROLX_SPLASH_MEDIA),video)
	RETROLX_SPLASH_POST_INSTALL_TARGET_HOOKS += RETROLX_SPLASH_INSTALL_VIDEO
endif

define RETROLX_SPLASH_INSTALL_SCRIPT
	mkdir -p $(TARGET_DIR)/etc/init.d
	install -m 0755 $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/core/retrolx-splash/S29splashscreencontrol	$(TARGET_DIR)/etc/init.d/
	install -m 0755 $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/core/retrolx-splash/$(RETROLX_SPLASH_SCRIPT)	$(TARGET_DIR)/etc/init.d/S03splash
	sed -i -e s+"%PLAYER_OPTIONS%"+"$(RETROLX_SPLASH_PLAYER_OPTIONS)"+g $(TARGET_DIR)/etc/init.d/S03splash
endef

define RETROLX_SPLASH_INSTALL_VIDEO
	mkdir -p $(TARGET_DIR)/usr/share/batocera/splash
	cp $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/core/retrolx-splash/splash.mp4 $(TARGET_DIR)/usr/share/batocera/splash
	echo -e "1\n00:00:00,000 --> 00:00:02,000\n$(RETROLX_SPLASH_TGVERSION)" > "${TARGET_DIR}/usr/share/batocera/splash/splash.srt"
endef

define RETROLX_SPLASH_INSTALL_IMAGE
	mkdir -p $(TARGET_DIR)/usr/share/batocera/splash
	convert "$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/core/retrolx-splash/logo.png" -fill white -pointsize 30 -annotate +50+1020 "$(RETROLX_SPLASH_TGVERSION)" "${TARGET_DIR}/usr/share/batocera/splash/logo-version.png"
endef

define RETROLX_SPLASH_INSTALL_ROTATE_RK3326_IMAGE
	mkdir -p $(TARGET_DIR)/usr/share/batocera/splash
	convert "$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/core/retrolx-splash/logo.png" -shave 150x0 -resize 480x320 -fill white -pointsize 15 -annotate +40+300 "$(RETROLX_SPLASH_TGVERSION)" -rotate -90 "${TARGET_DIR}/usr/share/batocera/splash/logo-version-320x480.png"
	convert "$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/core/retrolx-splash/logo.png"              -resize 854x480 -fill white -pointsize 15 -annotate +40+440 "$(RETROLX_SPLASH_TGVERSION)" -rotate -90 "${TARGET_DIR}/usr/share/batocera/splash/logo-version-480x854.png"
endef

define RETROLX_SPLASH_INSTALL_ROTATE_IMAGE
	mkdir -p $(TARGET_DIR)/usr/share/batocera/splash
	convert "$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/core/retrolx-splash/logo.png" -fill white -pointsize 30 -annotate +50+1020 "$(RETROLX_SPLASH_TGVERSION)" -rotate -90 "${TARGET_DIR}/usr/share/batocera/splash/logo-version.png"
endef

$(eval $(generic-package))
