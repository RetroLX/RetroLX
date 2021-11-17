PROJECT_DIR    := $(shell pwd)
DL_DIR         ?= $(PROJECT_DIR)/dl
OUTPUT_DIR     ?= $(PROJECT_DIR)/output
REPO_DIR       ?= $(PROJECT_DIR)/repo
CCACHE_DIR     ?= $(PROJECT_DIR)/buildroot-ccache
LOCAL_MK       ?= $(PROJECT_DIR)/batocera.mk
EXTRA_PKGS     ?=
MAKE_JLEVEL    ?= $(shell nproc)
BATCH_MODE     ?=
PARALLEL_BUILD ?=

-include $(LOCAL_MK)

ifdef PARALLEL_BUILD
	EXTRA_OPTS +=  BR2_PER_PACKAGE_DIRECTORIES=y
	MAKE_OPTS  += -j$(MAKE_JLEVEL)
endif

TARGETS := $(sort $(shell find $(PROJECT_DIR)/configs/ -name 'b*' | sed -n 's/.*\/retrolx-\(.*\)_defconfig/\1/p'))

UC = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')

vars:
	@echo "Supported targets:  $(TARGETS)"
	@echo "Project directory:  $(PROJECT_DIR)"
	@echo "Download directory: $(DL_DIR)"
	@echo "Build directory:    $(OUTPUT_DIR)"
	@echo "Pacman directory:   $(REPO_DIR)"
	@echo "ccache directory:   $(CCACHE_DIR)"
	@echo "Extra options:      $(EXTRA_OPTS)"
	@echo "Make options:       $(MAKE_OPTS)"

output-dir-%: %-supported
	mkdir -p $(OUTPUT_DIR)/$*
	mkdir -p $(REPO_DIR)/$*

ccache-dir:
	mkdir -p $(CCACHE_DIR)

dl-dir:
	mkdir -p $(DL_DIR)

%-supported:
	$(if $(findstring $*, $(TARGETS)),,$(error "$* not supported!"))

%-clean: output-dir-%
	 make O=$(OUTPUT_DIR)/$* BR2_EXTERNAL=$(PROJECT_DIR) -C $(PROJECT_DIR)/buildroot clean

%-config: output-dir-%
	  cp -f $(PROJECT_DIR)/configs/retrolx-$*_defconfig $(PROJECT_DIR)/configs/retrolx-$*_defconfig-tmp
	  for opt in $(EXTRA_OPTS); do \
		echo $$opt >> $(PROJECT_DIR)/configs/retrolx-$*_defconfig ; \
	  done
	  make O=$(OUTPUT_DIR)/$* BR2_EXTERNAL=$(PROJECT_DIR) -C $(PROJECT_DIR)/buildroot retrolx-$*_defconfig
	  mv -f $(PROJECT_DIR)/configs/retrolx-$*_defconfig-tmp $(PROJECT_DIR)/configs/retrolx-$*_defconfig

%-build: %-config ccache-dir dl-dir
	 make $(MAKE_OPTS) O=$(OUTPUT_DIR)/$* BR2_EXTERNAL=$(PROJECT_DIR) -C $(PROJECT_DIR)/buildroot $(CMD)

%-source: %-config ccache-dir dl-dir
	  make $(MAKE_OPTS) O=$(OUTPUT_DIR)/$* BR2_EXTERNAL=$(PROJECT_DIR) -C $(PROJECT_DIR)/buildroot source

%-kernel: %-config ccache-dir dl-dir
	  make $(MAKE_OPTS) O=$(OUTPUT_DIR)/$* BR2_EXTERNAL=$(PROJECT_DIR) -C $(PROJECT_DIR)/buildroot linux-menuconfig

%-graph-depends: %-config ccache-dir dl-dir
		 make O=$(OUTPUT_DIR)/$* BR2_EXTERNAL=$(PROJECT_DIR) BR2_GRAPH_OUT=svg -C $(PROJECT_DIR)/buildroot graph-depends

%-cleanbuild: %-clean %-build
	@echo

%-pkg:
	$(if $(PKG),,$(error "PKG not specified!"))
	$(MAKE) $*-build CMD=$(PKG)

%-webserver: output-dir-%
	$(if $(wildcard $(OUTPUT_DIR)/$*/images/retrolx/*),,$(error "$* not built!"))
	$(if $(shell which python 2>/dev/null),,$(error "python not found!"))
	@python3 -m http.server --directory $(OUTPUT_DIR)/$*/images/retrolx/images/$*/

%-rsync: output-dir-%
	$(eval TMP := $(call UC, $*)_IP)
	$(if $(shell which rsync 2>/dev/null),, $(error "rsync not found!"))
	$(if $($(TMP)),,$(error "$(TMP) not set!"))
	rsync -e "ssh -o 'UserKnownHostsFile /dev/null' -o StrictHostKeyChecking=no" -av $(OUTPUT_DIR)/$*/target/ root@$($(TMP)):/

%-tail: output-dir-%
	@tail -F $(OUTPUT_DIR)/$*/build/build-time.log

%-flash: %-supported
	$(if $(DEV),,$(error "DEV not specified!"))
	@gzip -dc $(OUTPUT_DIR)/$*/images/retrolx/images/$*/retrolx-*.img.gz | sudo dd of=$(DEV) bs=5M status=progress
	@sync

%-upgrade: %-supported
	$(if $(DEV),,$(error "DEV not specified!"))
	-@sudo umount /tmp/mount
	-@mkdir /tmp/mount
	@sudo mount $(DEV)1 /tmp/mount
	-@sudo rm /tmp/mount/boot/retrolx
	@sudo tar xvf $(OUTPUT_DIR)/$*/images/retrolx/boot.tar.xz -C /tmp/mount --no-same-owner
	@sudo umount /tmp/mount
	-@rmdir /tmp/mount

uart:
	$(if $(shell which picocom 2>/dev/null),, $(error "picocom not found!"))
	$(if $(SERIAL_DEV),,$(error "SERIAL_DEV not specified!"))
	$(if $(SERIAL_BAUDRATE),,$(error "SERIAL_BAUDRATE not specified!"))
	$(if $(wildcard $(SERIAL_DEV)),,$(error "$(SERIAL_DEV) not available!"))
	@picocom $(SERIAL_DEV) -b $(SERIAL_BAUDRATE)
