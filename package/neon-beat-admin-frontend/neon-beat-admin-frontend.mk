################################################################################
#
# neon-beat-frontend
#
################################################################################

NEON_BEAT_ADMIN_FRONTEND_VERSION = main
NEON_BEAT_ADMIN_FRONTEND_SITE = $(call github,neon-beat,neon-beat-admin-front,$(NEON_BEAT_ADMIN_FRONTEND_VERSION))
NEON_BEAT_ADMIN_FRONTEND_LICENSE = GPL-3.0
NEON_BEAT_ADMIN_FRONTEND_LICENSE_FILES = COPYING
NEON_BEAT_ADMIN_FRONTEND_DEPENDENCIES = host-nodejs


define NEON_BEAT_ADMIN_FRONTEND_DOWNLOAD_DEPS
	$(HOST_DIR)/usr/bin/npm --prefix $(@D) install
endef
NEON_BEAT_ADMIN_FRONTEND_POST_EXTRACT_HOOKS += NEON_BEAT_ADMIN_FRONTEND_DOWNLOAD_DEPS

define NEON_BEAT_ADMIN_FRONTEND_BUILD_CMDS
	VITE_API_BASE_URL='http://nbc.local:8080' $(HOST_DIR)/usr/bin/npm --prefix $(@D) run build
endef

define NEON_BEAT_ADMIN_FRONTEND_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/srv/www/admin
	cp -r $(@D)/dist/admin/* $(TARGET_DIR)/srv/www/admin
endef

$(eval $(generic-package))
