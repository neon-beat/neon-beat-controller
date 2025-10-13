################################################################################
#
# neon-beat-frontend
#
################################################################################

NEON_BEAT_FRONTEND_VERSION = main
NEON_BEAT_FRONTEND_SITE = $(call github,neon-beat,neon-beat-game-front,$(NEON_BEAT_FRONTEND_VERSION))
NEON_BEAT_FRONTEND_LICENSE = GPL-3.0
NEON_BEAT_FRONTEND_LICENSE_FILES = COPYING
NEON_BEAT_FRONTEND_DEPENDENCIES = host-nodejs


define NEON_BEAT_FRONTEND_DOWNLOAD_DEPS
	$(HOST_DIR)/usr/bin/npm --prefix $(@D) install
endef
NEON_BEAT_FRONTEND_POST_EXTRACT_HOOKS += NEON_BEAT_FRONTEND_DOWNLOAD_DEPS

define NEON_BEAT_FRONTEND_BUILD_CMDS
	$(HOST_DIR)/usr/bin/npm --prefix $(@D) run build
endef

define NEON_BEAT_FRONTEND_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/srv/www
	cp -r $(@D)/dist/* $(TARGET_DIR)/srv/www
	$(INSTALL) -D -m 644 $(NEON_BEAT_FRONTEND_PKGDIR)/data/lighttpd.conf \
		$(TARGET_DIR)/etc/lighttpd/lighttpd.conf
endef

define NEON_BEAT_FRONTEND_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(NEON_BEAT_FRONTEND_PKGDIR)/data/neon-beat-frontend.service \
		$(TARGET_DIR)/usr/lib/systemd/system/neon-beat-frontend.service
endef

$(eval $(generic-package))
