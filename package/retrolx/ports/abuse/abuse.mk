################################################################################
#
# Abuse
#
################################################################################
# Version.: Commits on Aug 18, 2021
ABUSE_VERSION = eb33c63145587454d9d6ce9e5d0d535208bc15e5
ABUSE_SITE = $(call github,Xenoveritas,abuse,$(ABUSE_VERSION))

ABUSE_DEPENDENCIES = sdl2 sdl2_mixer
ABUSE_SUPPORTS_IN_SOURCE_BUILD = NO
ABUSE_CONF_OPTS += -DASSETDIR=/usr/share/abuse

ABUSE_DATA_SITE = abuse.zoy.org/raw-attachment/wiki/download
ABUSE_DATA_SOURCE = abuse-data-2.00.tar.gz
ABUSE_DATA_LICENSE = Public Domain

define ABUSE_DATA_EXTRACT_CMDS
	cd $(ABUSE_DL_DIR) && wget $(ABUSE_DATA_SITE)/$(ABUSE_DATA_SOURCE)
	tar -xf $(ABUSE_DL_DIR)/$(ABUSE_DATA_SOURCE) -C $(@D)
endef

define ABUSE_DATA_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/abuse/
	cp -pvr $(@D)/* $(TARGET_DIR)/usr/share/abuse
endef

define ABUSE_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/abuse
	$(INSTALL) -D -m 0755 $(@D)/buildroot-build/src/abuse $(TARGET_DIR)/usr/bin/abuse
	cp -pvr $(@D)/data/* $(TARGET_DIR)/usr/share/abuse
	rm $(TARGET_DIR)/usr/share/abuse/CMakeLists.txt
	rm $(TARGET_DIR)/usr/share/abuse/READMD.md
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/abuse/abuse.keys $(TARGET_DIR)/usr/share/evmapy
endef

ABUSE_PRE_BUILD_HOOKS += ABUSE_DATA_EXTRACT_CMDS
ABUSE_POST_BUILD_HOOKS += ABUSE_DATA_INSTALL_TARGET_CMDS

$(eval $(cmake-package))
