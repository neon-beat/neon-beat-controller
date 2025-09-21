# SPDX-License-Identifier: GPL-2.0
# Strongly inspired by Buildroot Manual, section 9.1.2

.DEFAULT_GOAL := neon_beat_controller
.PHONY: neon_beat_controller

THIS_EXTERNAL_PATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# Put downloads in this directory instead of in the Buildroot directory
ifeq ($(BR2_DL_DIR),)
BR2_DL_DIR = $(THIS_EXTERNAL_PATH)/dl
endif

OUTPUT_DIR = $(THIS_EXTERNAL_PATH)/output
DOT_CONFIG= $(OUTPUT_DIR)/.config

MAKE_BUILDROOT = $(MAKE) -C $(OUTPUT_DIR)

$(DOT_CONFIG):
	$(MAKE) -C $(THIS_EXTERNAL_PATH)/buildroot O=$(OUTPUT_DIR) BR2_EXTERNAL=$(THIS_EXTERNAL_PATH) neon_beat_controller_defconfig

neon_beat_controller: $(DOT_CONFIG)
	$(MAKE_BUILDROOT)

%: $(DOT_CONFIG)
	$(MAKE_BUILDROOT) $@

