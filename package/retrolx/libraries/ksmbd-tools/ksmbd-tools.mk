################################################################################
#
# KSMBD_TOOLS
#
################################################################################

KSMBD_TOOLS_VERSION = 9b16a40931dee4bbad1f10124b6c72c529ddf83b
KSMBD_TOOLS_SITE =  $(call github,namjaejeon,ksmbd-tools,$(KSMBD_TOOLS_VERSION))
KSMBD_TOOLS_INSTALL_STAGING = YES
KSMBD_TOOLS_AUTORECONF = YES
KSMBD_TOOLS_DEPENDENCIES = host-pkgconf libnl libglib2

$(eval $(autotools-package))
