NAME = libdejector.a
VERSION = 0.1.0
IS_LIB = true 

ROOT_SOURCE_DIR = source

getSources = $(shell find $(ROOT_SOURCE_DIR) -name "*.d")
SRC = $(getSources) 

# -----------
# libraries
# -----------
# -----------
# Compiler flag
# -----------
DFLAGS += $(if $(IS_LIB), -lib, )



DFLAGS += $(if $(IS_LIB), -lib, )
## -debug compile in debug code
DFLAGS += -debug
## -g add symbolic debug info
#DFLAGS += -g 
## -w  warnings as errors (compilation will halt)
#DFLAGS += -w
##-wi warnings as messages (compilation will continue)
DFLAGS += -wi
DFLAGS += -m64

# -----------
# Linker flag
# -----------
#LDFLAGS += 
#LDFLAGS += -L-L/usr/lib/

## si usa make VERS=x
VERSION_FLAG = $(if $(VERS), -version=$(VERS), )

###############
# TEST 
###############

SRC_TEST = $(filter-out $(ROOT_SOURCE_DIR)/app.d, $(SRC)) 
SRC_TEST += $(wildcard tests/*.d)

# -----------
# test libraries
# -----------
LIB_TEST += $(LIB)
INCLUDES_TEST += $(INCLUDES)

LIB_TEST += $(D_DIR)/unit-threaded/libunit-threaded.a
INCLUDES_TEST += -I$(D_DIR)/unit-threaded/source

# -----------
# test flags
# -----------

DFLAGS_TEST += -unittest

PKG = $(wildcard $(BIN)/$(NAME))
PKG_SRC = $(PKG) $(SRC) makefile

###############
# Common part
###############
DEFAULT: all
BIN = bin
DMD = dmd
BASE_NAME = $(basename $(NAME))
NAME_TEST = dejector-test 
DSCAN = $(D_DIR)/Dscanner/bin/dscanner
.PHONY: all clean clobber test run

all: builddir $(BIN)/$(NAME)

builddir:
	@mkdir -p $(BIN)

$(BIN)/$(NAME): $(SRC) $(LIB)| builddir
	$(DMD) $^ $(DFLAGS) $(INCLUDES) $(LDFLAGS) $(VERSION_FLAG) -of$@

run: all
	$(BIN)/$(NAME)

## se si usa unit_threaded
## make test T=nome_test
test: $(BIN)/$(NAME_TEST)
	@$(BIN)/$(NAME_TEST) $(T)

$(BIN)/$(NAME_TEST): $(SRC_TEST) $(LIB_TEST)| builddir
	$(DMD) $^ $(DFLAGS_TEST) $(INCLUDES_TEST) $(LDFLAGS) $(VERSION_FLAG) -of$@

pkgdir:
	@mkdir -p pkg

pkg: $(PKG) | pkgdir
	tar -jcf pkg/$(BASE_NAME)-$(VERSION).tar.bz2 $^
	zip pkg/$(BASE_NAME)-$(VERSION).zip $^

pkgsrc: $(PKG_SRC) | pkgdir
	tar -jcf pkg/$(BASE_NAME)-$(VERSION)-src.tar.bz2 $^

tags: $(SRC)
	$(DSCAN) --ctags $^ > tags

style: $(SRC)
	$(DSCAN) --styleCheck $^

syn: $(SRC)
	$(DSCAN) --syntaxCheck $^

loc: $(SRC)
	$(DSCAN) --sloc $^

clean:
	-rm -f $(BIN)/*.o
	-rm -f $(BIN)/__*

clobber:
	-rm -f $(BIN)/*

var:
	@echo $(D_DIR):$($(D_DIR))
	@echo SRC:$(SRC)
	@echo INCLUDES: $(INCLUDES)
	@echo
	@echo DFLAGS: $(DFLAGS)
	@echo LDFLAGS: $(LDFLAGS)
	@echo VERSION: $(VERSION_FLAG)
	@echo
	@echo NAME_TEST: $(NAME_TEST)
	@echo SRC_TEST: $(SRC_TEST)
	@echo INCLUDES_TEST: $(INCLUDES_TEST)
	@echo T: $(T)

