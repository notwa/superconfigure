
KISSAT_SRC := https://github.com/arminbiere/kissat/archive/refs/heads/master.tar.gz

$(eval $(call DOWNLOAD_SOURCE,cli/kissat,$(KISSAT_SRC)))

o/cli/kissat/configured.x86_64: CONFIG_COMMAND = $(BASELOC)/cli/kissat/configure
o/cli/kissat/configured.aarch64: CONFIG_COMMAND = $(BASELOC)/cli/kissat/configure

o/cli/kissat/built.fat: BINS = kissat kitten
