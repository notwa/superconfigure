YICES2_SRC := https://github.com/SRI-CSL/yices2/archive/refs/heads/master.tar.gz
YICES2_DEPS := lib/gmp solver/kissat

$(eval $(call DOWNLOAD_SOURCE,solver/yices2,$(YICES2_SRC)))
$(eval $(call SPECIFY_DEPS,solver/yices2,$(YICES2_DEPS)))

o/solver/yices2/setup: o/solver/yices2/patched
	cd o/solver/yices2/yices2-* && autoconf || true
	touch $@

o/solver/yices2/configured.x86_64: o/solver/yices2/setup
o/solver/yices2/configured.aarch64: o/solver/yices2/setup

o/solver/yices2/configured.x86_64: CONFIG_COMMAND = $(BASELOC)/solver/yices2/config-wrapper
o/solver/yices2/configured.aarch64: CONFIG_COMMAND = $(BASELOC)/solver/yices2/config-wrapper

o/solver/yices2/built.x86_64: BUILD_COMMAND = $(BUILD_DEFAULT) static-dist MODE=release
o/solver/yices2/built.aarch64: BUILD_COMMAND = $(BUILD_DEFAULT) static-dist MODE=release

o/solver/yices2/installed.x86_64: INSTALL_COMMAND = $(INSTALL_DEFAULT) MODE=release
o/solver/yices2/installed.aarch64: INSTALL_COMMAND = $(INSTALL_DEFAULT) MODE=release

o/solver/yices2/built.fat: BINS = yices yices-sat yices-smt yices-smt2
