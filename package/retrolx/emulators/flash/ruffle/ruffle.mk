################################################################################
#
# RUFFLE
#
################################################################################
# Version.: Commits on May 21, 2022
RUFFLE_VERSION = cf820b4f9576ff0ad8873c6a8ce0fbab36dec565
RUFFLE_SITE = $(call github,ruffle-rs,ruffle,$(RUFFLE_VERSION))
RUFFLE_LICENSE = GPLv2
RUFFLE_DEPENDENCIES = host-rustc openssl

RUFFLE_ARGS_FOR_BUILD = -L $(STAGING_DIR) -Wl,-rpath,$(STAGING_DIR)

RUFFLE_CARGO_ENV = \
    CARGO_HOME=$(HOST_DIR)/usr/share/cargo \
    RUSTFLAGS='$(addprefix -C linker=$(TARGET_CC) -C link-args=,$(RUFFLE_ARGS_FOR_BUILD))'
    #RUST_TARGET_PATH=$(HOST_DIR)/etc/rustc \
    #PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) \
    #PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig \
    #TARGET_CC=$(TARGET_CC) \
    #TARGET_CXX=$(TARGET_CXX) \
    #TARGET_LD=$(TARGET_LD)

RUFFLE_CARGO_MODE = $(if $(BR2_ENABLE_DEBUG),,release)
RUFFLE_BIN_DIR = target/$(RUSTC_TARGET_NAME)/$(RUFFLE_CARGO_MODE)

RUFFLE_CARGO_OPTS = \
    --$(RUFFLE_CARGO_MODE) \
    --target=$(BR2_ARCH)-unknown-linux-gnu \
    --manifest-path=$(@D)/Cargo.toml

define RUFFLE_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(RUFFLE_CARGO_ENV) \
            cargo build $(RUFFLE_CARGO_OPTS)
endef

define RUFFLE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin

	cp -pr $(@D)/$(RUFFLE_BIN_DIR)/ruffle_desktop $(TARGET_DIR)/usr/bin/ruffle

	# evmap config
	#mkdir -p $(TARGET_DIR)/usr/share/evmapy
	#cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/flash/ruffle/flash.ruffle.keys $(TARGET_DIR)/usr/share/evmapy
endef

$(eval $(generic-package))
