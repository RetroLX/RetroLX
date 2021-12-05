################################################################################
#
# KSMBD_TOOLS
#
################################################################################

KSMBD_TOOLS_VERSION = 402195f4f608f31dc630a71b27d0e1c767df8d17
KSMBD_TOOLS_SITE =  $(call github,namjaejeon,ksmbd-tools,$(KSMBD_TOOLS_VERSION))
KSMBD_TOOLS_INSTALL_STAGING = YES
KSMBD_TOOLS_AUTORECONF = YES
KSMBD_TOOLS_DEPENDENCIES = host-pkgconf libnl libglib2

$(eval $(autotools-package))
