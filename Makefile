# SPDX-License-Identifier: GPL-2.0
# Strongly inspired by Buildroot Manual, section 9.1.2

.DEFAULT_GOAL := neon-beat-controller
.PHONY: neon-beat-controller

THIS_EXTERNAL_PATH := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

OUTPUT_DIR = $(THIS_EXTERNAL_PATH)/output
DOT_CONFIG= $(OUTPUT_DIR)/.config

MAKE_BUILDROOT = $(MAKE) -C $(OUTPUT_DIR)

$(DOT_CONFIG):
	$(MAKE) -C $(THIS_EXTERNAL_PATH)/buildroot O=$(OUTPUT_DIR) BR2_EXTERNAL=$(THIS_EXTERNAL_PATH) neon-beat-controller_defconfig

neon-beat-controller: $(DOT_CONFIG)
	$(MAKE_BUILDROOT)

%: $(DOT_CONFIG)
	$(MAKE_BUILDROOT) $@

