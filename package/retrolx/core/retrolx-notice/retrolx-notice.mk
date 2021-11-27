################################################################################
#
# RetroLX notice
#
################################################################################
RETROLX_NOTICE_VERSION = a4f47be043e4149c76f59f7daf18c5653131e73b
RETROLX_NOTICE_SITE = $(call github,RetroLX,retrolx-notice,$(RETROLX_NOTICE_VERSION))

define RETROLX_NOTICE_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/retrolx/doc
    cp -r $(@D)/notice.pdf $(TARGET_DIR)/usr/share/retrolx/doc/notice.pdf
endef

$(eval $(generic-package))
