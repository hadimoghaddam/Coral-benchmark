ARCH=$(shell uname -s)


include ../../../Params.inc
include ../../../bld/Makefile.$(ARCH)

BUILDIR=.
TARGET = $(BUILDDIR)/libmetis.a
INCLUDES = -I.

#CFLAGS = $(COPTIONS) $(OPTFLAGS) $(INCLUDES)

SRC = coarsen.c fm.c initpart.c match.c ccgraph.c memory.c \
       pmetis.c pqueue.c refine.c util.c timing.c debug.c \
       bucketsort.c graph.c stat.c kmetis.c kwayrefine.c \
       kwayfm.c balance.c ometis.c srefine.c sfm.c separator.c \
       mincover.c mmd.c mesh.c meshpart.c frename.c fortran.c \
       myqsort.c compress.c parmetis.c estmem.c \
       mpmetis.c mcoarsen.c mmatch.c minitpart.c mbalance.c \
       mrefine.c mutil.c mfm.c mkmetis.c mkwayrefine.c mkwayfmh.c \
       mrefine2.c minitpart2.c mbalance2.c mfm2.c \
       kvmetis.c kwayvolrefine.c kwayvolfm.c subdomains.c

OBJS = $(SRC:.c=.o)

all: $(TARGET)

#
# This method of specifying the library target allows a parallel make 
# but forces a single execution of the AR command (which will fail in parallel)
#

$(TARGET) : $(SRC)
	$(MAKE) $(?:.c=.o)
	$(AR) $(ARFLAGS) $@ $(?:.c=.o)
	$(RANLIB) $@
	$(RM) $(?:.c=.o)


clean:
	rm -f *.o

realclean:
	rm -f *.o ; rm -f $(TARGET)
