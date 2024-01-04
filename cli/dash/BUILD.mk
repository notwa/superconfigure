
DASH_CONFIG_ARGS = --enable-static --disable-lineno\
				   --disable-fnmatch --disable-glob\
				   --without-libedit\
				   --prefix=$$(COSMOS)

o/cli/dash/downloaded: \
	DL_COMMAND = rm -rf dash &&\
		git clone --quiet --depth=1 git://git.kernel.org/pub/scm/utils/dash/dash.git

o/cli/dash/patched: \
	PATCH_COMMAND = $(DUMMY)

o/cli/dash/setup: o/cli/dash/patched
	cd o/cli/dash/dash* && ./autogen.sh
	touch $@

o/cli/dash/configured.x86_64: o/lib/pcre/setup
o/cli/dash/configured.aarch64: o/lib/pcre/setup

$(eval $(call AUTOTOOLS_BUILD,cli/dash,$(DASH_CONFIG_ARGS),$(DASH_CONFIG_ARGS)))

o/cli/dash/built.fat: BINS = dash
