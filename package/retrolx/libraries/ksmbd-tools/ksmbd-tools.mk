################################################################################
#
# KSMBD_TOOLS
#
################################################################################

KSMBD_TOOLS_VERSION = a47af62bc4c7e8e486b318347cee03e40b0ea40b
KSMBD_TOOLS_SITE =  $(call github,namjaejeon,ksmbd-tools,$(KSMBD_TOOLS_VERSION))
KSMBD_TOOLS_INSTALL_STAGING = YES
KSMBD_TOOLS_AUTORECONF = YES
KSMBD_TOOLS_DEPENDENCIES = host-pkgconf libnl libglib2

$(eval $(autotools-package))
