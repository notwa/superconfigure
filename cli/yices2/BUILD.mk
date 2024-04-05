YICES2_SRC := https://github.com/SRI-CSL/yices2/archive/refs/heads/master.tar.gz
YICES2_DEPS := lib/gmp bin/kissat

$(eval $(call DOWNLOAD_SOURCE,cli/yices2,$(YICES2_SRC)))
$(eval $(call AUTOTOOLS_BUILD,cli/yices2,$(YICES2_CONFIG_ARGS),$(YICES2_CONFIG_ARGS)))

o/web/yices2/setup: o/web/yices2/patched
	cd o/web/yices2/yices2* && autoconf || true
	touch $@

o/cli/yices2/configured.x86_64: CONFIG_COMMAND = $(BASELOC)/cli/yices2/config-wrapper
o/cli/yices2/configured.aarch64: CONFIG_COMMAND = $(BASELOC)/cli/yices2/config-wrapper

o/cli/yices2/built.x86_64: BUILD_COMMAND = $(BUILD_DEFAULT) static-dist
o/cli/yices2/built.aarch64: BUILD_COMMAND = $(BUILD_DEFAULT) static-dist

o/cli/yices2/built.fat: FATTEN_COMMAND = $(BASELOC)/config/apelink_folder.sh
o/cli/yices2/built.fat: BINS = yices yices_sat yices_sat_new yices_smt yices_smt2 yices_smtcomp
