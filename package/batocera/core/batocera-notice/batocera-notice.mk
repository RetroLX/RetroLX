################################################################################
#
# Batocera notice
#
################################################################################
RETROLX_NOTICE_VERSION = e6241340d292dee20406a0567262a78ff34d45f7
RETROLX_NOTICE_SITE = $(call github,batocera-linux,batocera-notice,$(RETROLX_NOTICE_VERSION))

define RETROLX_NOTICE_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/batocera/doc
    cp -r $(@D)/notice.pdf $(TARGET_DIR)/usr/share/batocera/doc/notice.pdf
endef

$(eval $(generic-package))
