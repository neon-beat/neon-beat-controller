################################################################################
#
# couchdb
#
################################################################################

COUCHDB_VERSION = 3.4.3
COUCHDB_SITE = https://www.apache.org/dist/couchdb/source/$(COUCHDB_VERSION)
COUCHDB_SOURCE = apache-couchdb-$(COUCHDB_VERSION).tar.gz

COUCHDB_LICENSE = Apache-2.0
COUCHDB_LICENSE_FILES = LICENSE
COUCHDB_DEPENDENCIES = \
		       host-erlang \
		       erlang \
		       quickjs \
		       icu
			
COUCHDB_KEEP_DEPENDENCIES = YES
COUCHDB_CONF_OPTS = \
	--js-engine=quickjs \
	--disable-spidermonkey \
	--disable-docs \
	--disable-fauxton
COUCHDB_MAKE_OPTS = release
COUCHDB_MAKE_ENV = \
		   CC=$(TARGET_CC) \
		   CXX=$(TARGET_CXX) \
		   ERL_CFLAGS=-I$(STAGING_DIR)/usr/lib/erlang/usr/include \
		   ERL_EI_LIBDIR=$(STAGING_DIR)/usr/lib/erlang/lib/erl_interface-5.4/lib \
		   LDFLAGS=-L${STAGING_DIR}/erlang/lib/erl_interface-5.4/lib \
		   CROSS_PREFIX=$(TARGET_CROSS)


define COUCHDB_POST_CONFIGURE_FIXUP
	sed -i  "/{sys/ a {root_dir, \"${STAGING_DIR}/usr/lib/erlang\"}," ${@D}/rel/reltool.config
	sed -i 's:"^erts.*/bin/(dialyzer|typer)":"^erts.*/bin/(dialyzer|typer)", "^erts.*/lib":g' ${@D}/rel/reltool.config
endef
COUCHDB_POST_CONFIGURE_HOOKS += COUCHDB_POST_CONFIGURE_FIXUP

define COUCHDB_USERS
	couchdb -1 couchdb -1 * /home/couchdb - - CouchdB Administrator
endef

define COUCHDB_PERMISSIONS
	/home/couchdb r -1 couchdb couchdb - - - - -
endef

define COUCHDB_INSTALL_TARGET_CMDS
	cp -r $(@D)/rel/couchdb $(TARGET_DIR)/home
	$(INSTALL) -D -m 644 $(COUCHDB_PKGDIR)/data/local.ini \
		$(TARGET_DIR)/home/couchdb/etc/local.ini
endef

define COUCHDB_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(COUCHDB_PKGDIR)/data/couchdb.service \
		$(TARGET_DIR)/usr/lib/systemd/system/couchdb.service
endef

$(eval $(autotools-package))
