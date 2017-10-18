ARCH=$(shell uname -s)

BUILDDIR = .

TARGET = $(BUILDDIR)/libnetcdf_stubs.a

SRC = typeSizes.f90 netcdf_stubs.f90

OBJS = $(SRC:.f90=.o)

.SUFFIXES: .f90 .o

include ../../Params.inc
include ../../bld/Makefile.$(ARCH)

%.o:%.f90
	$(F90) $(FFLAGS) -c $<

all: $(TARGET)

$(TARGET) : $(SRC)
	$(MAKE) $(?:.f90=.o)
	$(AR) $(ARFLAGS) $@ $(?:.f90=.o)
	$(RANLIB) $@
	$(RM) $(?:.f90=.o)

clean:
	$(RM) $(?:.f90=.o) *.mod *.a
