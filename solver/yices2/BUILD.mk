YICES2_SRC := https://github.com/SRI-CSL/yices2/archive/refs/heads/master.tar.gz
YICES2_DEPS := lib/gmp cli/kissat

$(eval $(call DOWNLOAD_SOURCE,cli/yices2,$(YICES2_SRC)))
$(eval $(call SPECIFY_DEPS,cli/yices2,$(YICES2_DEPS)))

o/cli/yices2/setup: o/cli/yices2/patched
	cd o/cli/yices2/yices2-* && autoconf || true
	touch $@

o/cli/yices2/configured.x86_64: o/cli/yices2/setup
o/cli/yices2/configured.aarch64: o/cli/yices2/setup

o/cli/yices2/configured.x86_64: CONFIG_COMMAND = $(BASELOC)/cli/yices2/config-wrapper
o/cli/yices2/configured.aarch64: CONFIG_COMMAND = $(BASELOC)/cli/yices2/config-wrapper

o/cli/yices2/built.x86_64: BUILD_COMMAND = $(BUILD_DEFAULT) static-dist MODE=release
o/cli/yices2/built.aarch64: BUILD_COMMAND = $(BUILD_DEFAULT) static-dist MODE=release

o/cli/yices2/installed.x86_64: INSTALL_COMMAND = $(INSTALL_DEFAULT) MODE=release
o/cli/yices2/installed.aarch64: INSTALL_COMMAND = $(INSTALL_DEFAULT) MODE=release

o/cli/yices2/built.fat: BINS = yices yices-sat yices-smt yices-smt2
