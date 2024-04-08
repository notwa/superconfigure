# TODO: automatically handle header dependencies.

ARFLAGS := rcsD
CFLAGS := $(CFLAGS) -Wall -O3 -DNDEBUG
LDLIBS := $(LDLIBS) -lm

BIN ?= ./bin
INC ?= ./include
LIB ?= ./lib
OBJ ?= ./o
SRC ?= ./src
TMPDIR ?= $(OBJ)/tmp

OBJS := $(patsubst $(SRC)/%.c,$(OBJ)/%.o,$(wildcard $(SRC)/*.c))
BIN_OBJS := $(addprefix $(OBJ)/,main.o application.o handle.o parse.o witness.o)
LIB_OBJS := $(filter-out $(BIN_OBJS),$(OBJS))

BINS = $(BIN)/kissat $(BIN)/kitten
INCS = $(INC)/kissat.h
SHARED_LIBS =
STATIC_LIBS = $(LIB)/libkissat.a
GARBAGE = # for clean target

# boring stuff, as suggested by GNU:

INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

prefix ?= /usr/local
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin
includedir ?= $(prefix)/include
libdir ?= $(exec_prefix)/lib

# exciting stuff:

.PHONY: all
all: $(BINS) $(INCS) $(SHARED_LIBS) $(STATIC_LIBS)

$(BIN)/kissat: $(BIN_OBJS) $(LIB)/libkissat.a | $(BIN)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
GARBAGE += $(BIN)/kissat

$(BIN)/kitten: CFLAGS := $(CFLAGS) -DSTAND_ALONE_KITTEN
$(BIN)/kitten: $(SRC)/kitten.c | $(BIN)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
GARBAGE += $(BIN)/kitten

$(LIB)/libkissat.a: $(LIB_OBJS) | $(LIB)
	$(AR) $(ARFLAGS) $@ $^
GARBAGE += $(LIB)/libkissat.a

$(INC)/kissat.h: $(SRC)/kissat.h | $(INC)
	cp $< $@
GARBAGE += $(INC)/kissat.h

$(OBJ)/%.o: $(SRC)/%.c | $(OBJ)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
$(OBJ)/build.o: $(TMPDIR)/build.h
$(OBJ)/build.o: CFLAGS := $(CFLAGS) -I$(TMPDIR)
GARBAGE += $(OBJS)

$(TMPDIR)/build.h: | $(TMPDIR)
	$(file >$@)
	$(CC) --version > $(TMPDIR)/COMPILER
	if test -d $(SRC)/../.git; then git show > $(TMPDIR)/ID; else echo unknown > $(TMPDIR)/ID; fi
	date -u '+%Y/%m/%d %H:%M:%S' > $(TMPDIR)/BUILD_DATE
	uname -srmn >> $(TMPDIR)/BUILD_UNAME
	pwd >> $(TMPDIR)/DIR
	awk '{printf "#define VERSION     \"%s\"\n", $$0; exit}' < $(SRC)/../VERSION >> $@
	awk '{printf "#define COMPILER    \"%s\"\n", $$0; exit}' < $(TMPDIR)/COMPILER >> $@
	awk '{printf "#define ID          \"%s\"\n", $$2; exit}' < $(TMPDIR)/ID >> $@
	awk '{printf "#define BUILD_DATE  \"%s\"\n", $$0; exit}' < $(TMPDIR)/BUILD_DATE >> $@
	awk '{printf "#define BUILD_UNAME \"%s\"\n", $$0; exit}' < $(TMPDIR)/BUILD_UNAME >> $@
	awk '{printf "#define DIR         \"%s\"\n", $$0; exit}' < $(TMPDIR)/DIR >> $@
	printf %s\\n '#define BUILD BUILD_DATE " " BUILD_UNAME' >> $@
GARBAGE += $(addprefix $(TMPDIR)/,build.h COMPILER ID BUILD_DATE BUILD_UNAME DIR)

$(BIN) $(INC) $(LIB) $(OBJ) $(TMPDIR):
	mkdir -p $@

.PHONY: clean
clean:
	-rm -f $(GARBAGE)
	-for d in $(TMPDIR) $(OBJ) $(LIB) $(INC) $(BIN); do ! test -d "$$d" || rmdir "$$d"; done

.PHONY: install
install:
	for d in $(bindir) $(includedir) $(libdir); do $(INSTALL) -d $(DESTDIR)"$$d" || exit; done
	for f in $(INCS); do $(INSTALL_DATA) "$$f" $(DESTDIR)$(includedir)/ || exit; done
	for f in $(BINS); do $(INSTALL_PROGRAM) "$$f" $(DESTDIR)$(bindir)/ || exit; done
	for f in $(SHARED_LIBS); do $(INSTALL_PROGRAM) "$$f" $(DESTDIR)$(libdir)/ || exit; done
	for f in $(STATIC_LIBS); do $(INSTALL_DATA) "$$f" $(DESTDIR)$(libdir)/ || exit; done
