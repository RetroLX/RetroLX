################################################################################
#
# KSMBD_TOOLS
#
################################################################################

KSMBD_TOOLS_VERSION = 2f8cfd97fd1f494f651a1a40db1be54138d558a5
KSMBD_TOOLS_SITE =  $(call github,namjaejeon,ksmbd-tools,$(KSMBD_TOOLS_VERSION))
KSMBD_TOOLS_INSTALL_STAGING = YES
KSMBD_TOOLS_AUTORECONF = YES
KSMBD_TOOLS_DEPENDENCIES = host-pkgconf libnl libglib2

$(eval $(autotools-package))
