
KISSAT_SRC := https://github.com/arminbiere/kissat/archive/refs/tags/rel-4.0.2.tar.gz

$(eval $(call DOWNLOAD_SOURCE,solver/kissat,$(KISSAT_SRC)))

o/solver/kissat/configured.x86_64: CONFIG_COMMAND = $(BASELOC)/solver/kissat/configure
o/solver/kissat/configured.aarch64: CONFIG_COMMAND = $(BASELOC)/solver/kissat/configure

o/solver/kissat/built.fat: BINS = kissat kitten
