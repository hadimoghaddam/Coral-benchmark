##################################################
# Makefile for HOMME 
##################################################
# Staggering decided at compile time in Params.inc
.SUFFIXES: .F90 .o .a 
ARCH =$(shell uname -s)
include ../Params.inc
include ../bld/Makefile.$(ARCH)


FDEFS += $(DEF)$(RESTART) $(DEF)_$(ARCH) $(DEF)$(OMP) $(DEF)$(GRID_STAG) \
        $(DEF)NP=$(NP) $(DEF)PLEV=$(PLEV) $(DEF)_WK_GRAD  $(DEF)SPHEREW \
#         $(DEF)_REFSOLN



EXE = sweqx

SRC +=	state_mod.F90 init_mod.F90 shallow_water_mod.F90 \
	sweq_mod.F90 restart_mod.F90 advance_mod.F90 \
        shal_movie_mod.F90 types_mod.F90 rk_mod.F90

MAIN = main.F90
OBJ = $(filter %.o,$(SRC:.F90=.o) $(SRC:.c=.o))

LIB = libsweq.a 

EXEID_tmp=$(PLEV)$(NP)$(PCOLS)$(PCNST)$(PNATS)$(OBJDIRSFX)

EXEID=$(strip $(EXEID_tmp))

OBJDIR=objsw.$(EXEID)

OBJFP = $(addprefix $(OBJDIR)/,$(OBJ))

CPPDEFS = $(subst $(DEF),-D, $(FDEFS))

FINCS =  $(BLDPATH) $(NETCDFINC)

DEPENDS = ../bld/Depends.sw.$(OBJDIRSFX)

SUPPORTDIRS = $(addprefix ../libs/,$(SUPPORT))

VPATH+=$(OBJDIR)

default: $(EXE) 

EXEID=$(PLEV)$(NP)$(PCOLS)$(PCNST)$(PNATS)$(OBJDIRSFX)

MFLAGS += $(MODPATH_FLAG)./$(OBJDIR) -I./$(OBJDIR)


$(EXE): $(MAIN) $(DEPENDS) $(OBJDIR) $(OBJ)
	$(F90) $(FFLAGS) $(MFLAGS) $(FDEFS) $(FINCS) $(FREE) $(OMP_FLAGS) $< -o $@ $(OBJFP) $(NETCDFLIB) $(LDFLAGS)

$(OBJDIR):
	mkdir $(OBJDIR)

%.o : %.F90
	$(PRECOMP)
	$(F90) $(FFLAGS) $(MFLAGS) $(FDEFS) $(FINCS) $(FREE) $(OMP_FLAGS) -c $< -o $(OBJDIR)/$@
	$(POSTCOMP)

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $(OBJDIR)/$@

dep:  $(DEPENDS)

# Depends currently only works for F90 
$(DEPENDS):
	$(MKDEPF90) $(CPPDEFS) -I "$(VPATH)" $(MAIN) $(filter %.F90,$(SRC)) > $@

include ./$(DEPENDS)

