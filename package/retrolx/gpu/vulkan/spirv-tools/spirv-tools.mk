################################################################################
#
# spirv-tools
#
################################################################################

SPIRV_TOOLS_VERSION = d645ea270504fa9e577905c03e1da086e4fb0c73
SPIRV_TOOLS_SITE = $(call github,KhronosGroup,SPIRV-Tools,$(SPIRV_TOOLS_VERSION))
SPIRV_TOOLS_DEPENDENCIES = spirv-headers

SPIRV_TOOLS_CONF_OPTS += -DSPIRV-Headers_SOURCE_DIR="$(BUILD_DIR)/spirv-headers-$(SPIRV_HEADERS_VERSION)"

SPIRV_TOOLS_INSTALL_STAGING = YES

$(eval $(cmake-package))
