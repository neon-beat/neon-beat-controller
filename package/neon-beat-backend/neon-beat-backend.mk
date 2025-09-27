################################################################################
#
# neon-beat-backend
#
################################################################################

NEON_BEAT_BACKEND_VERSION = main
NEON_BEAT_BACKEND_SITE = $(call github,neon-beat,neon-beat-back,$(NEON_BEAT_BACKEND_VERSION))
NEON_BEAT_BACKEND_LICENSE = GPL-3.0
NEON_BEAT_BACKEND_LICENSE_FILES = COPYING

$(eval $(cargo-package))
