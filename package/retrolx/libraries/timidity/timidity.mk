################################################################################
#
# TIMIDITY
#
################################################################################

TIMIDITY_VERSION = 0.2.7
TIMIDITY_SOURCE = libtimidity-${TIMIDITY_VERSION}.tar.gz
TIMIDITY_SITE =  https://downloads.sourceforge.net/project/libtimidity/libtimidity/$(TIMIDITY_VERSION)
TIMIDITY_INSTALL_STAGING = YES
TIMIDITY_AUTORECONF = YES
TIMIDITY_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
