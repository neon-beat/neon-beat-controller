################################################################################
#
# neon-beat-backend
#
################################################################################

NEON_BEAT_BACKEND_VERSION = 0.8.3
NEON_BEAT_BACKEND_SITE = $(call github,neon-beat,neon-beat-back,v$(NEON_BEAT_BACKEND_VERSION))
NEON_BEAT_BACKEND_LICENSE = GPL-3.0
NEON_BEAT_BACKEND_LICENSE_FILES = COPYING
NEON_BEAT_BACKEND_CARGO_BUILD_OPTS = \
				     --bin neon-beat-back \
				     --no-default-features \
				     --features couch-store
NEON_BEAT_BACKEND_CARGO_INSTALL_OPTS = \
				       --bin neon-beat-back \
				       --no-default-features \
				       --features couch-store

define NEON_BEAT_BACKEND_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(NEON_BEAT_BACKEND_PKGDIR)/data/neon-beat-backend.service \
		$(TARGET_DIR)/usr/lib/systemd/system/neon-beat-backend.service
endef

$(eval $(cargo-package))
