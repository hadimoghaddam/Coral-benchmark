AUTOMAKE_OPTIONS = foreign
# Relevant Directories within the HOMME repository
# holding source files needed for building the library
# and executable swdgx.

SRC = ../../src
SRC_SHARE = $(SRC)/share
UTILS = ../../utils/csm_share
INCLUDES =  -I../../utils/pio -I../../utils/timing -I ../../src -I../../src/share $(HOMME_INCLUDE)
AM_FCFLAGS= $(MY_DEFS)
AM_LDFLAGS = $(LOCAL_BLAS_LOCATION) $(LOCAL_LAPACK_LOCATION) $(HOMME_LDFLAGS)


SRCS_F90=    	$(SRC_SHARE)/kinds.F90 \
	        $(SRC_SHARE)/dimensions_mod.F90 \
		$(SRC_SHARE)/control_mod.F90 \
		$(SRC_SHARE)/physical_constants.F90 \
		$(SRC_SHARE)/quadrature_mod.F90 \
		$(SRC_SHARE)/parallel_mod.F90 \
		$(SRC_SHARE)/hybrid_mod.F90 \
		$(SRC_SHARE)/reduction_mod.F90 \
		$(SRC_SHARE)/params_mod.F90 \
		$(SRC_SHARE)/gridgraph_mod.F90 \
		$(SRC_SHARE)/coordinate_systems_mod.F90 \
		$(SRC_SHARE)/edge_mod.F90 \
		$(SRC_SHARE)/element_mod.F90 \
		$(SRC_SHARE)/global_norms_mod.F90 \
		$(SRC_SHARE)/thread_mod.F90 \
		$(SRC_SHARE)/ll_mod.F90 \
		$(SRC_SHARE)/metagraph_mod.F90 \
		$(SRC_SHARE)/schedule_mod.F90 \
		$(SRC_SHARE)/bndry_mod.F90 \
		$(SRC_SHARE)/derivative_mod.F90 \
		$(SRC_SHARE)/viscosity_mod.F90 \
		$(SRC_SHARE)/time_mod.F90 \
		$(SRC)/common_io_mod.F90 \
		$(SRC)/pio_io_mod.F90 \
		$(SRC_SHARE)/spacecurve_mod.F90 \
		$(SRC_SHARE)/cube_mod.F90 \
		$(SRC_SHARE)/interpolate_mod.F90 \
		$(SRC)/interp_movie_mod.F90 \
		$(UTILS)/shr_kind_mod.F90 \
		$(UTILS)/shr_mpi_mod.F90 \
		$(UTILS)/shr_sys_mod.F90 \
		$(UTILS)/shr_file_mod.F90 \
		$(UTILS)/shr_vmath_mod.F90 \
		$(UTILS)/shr_vmath_fwrap.c \
		$(SRC_SHARE)/domain_mod.F90 \
		$(SRC)/restart_io_mod.F90 \
		$(SRC_SHARE)/cg_mod.F90 \
		$(SRC_SHARE)/linear_algebra_mod.F90 \
		$(SRC_SHARE)/solver_mod.F90 \
		$(SRC_SHARE)/filter_mod.F90 \
		$(SRC)/dg_flux_mod.F90 \
		$(SRC)/dg_core_mod.F90 \
		$(SRC)/dg_tests_mod.F90 \
		$(SRC)/dg_tvdrk_mod.F90 \
		$(SRC)/state_mod.F90 \
		$(SRC)/dg_sweq_mod.F90 \
		$(SRC)/common_movie_mod.F90 \
		$(SRC_SHARE)/namelist_mod.F90 \
		$(SRC_SHARE)/mass_matrix_mod.F90 \
		$(SRC_SHARE)/dof_mod.F90 \
		$(SRC_SHARE)/perfmodel_mod.F90 \
		$(SRC_SHARE)/metis_mod.F90 \
		$(SRC)/checksum_mod.F90 \
		$(SRC)/repro_sum_mod.F90 \
		$(SRC)/restart_mod.F90 \
		$(SRC)/init_mod.F90 \
		$(SRC)/dg_movie_mod.F90 \
		$(SRC_SHARE)/mesh_mod.F90 

FDEPENDS=../../helpers/fdepends.awk
DEPSUF = .d
DEPENDS :=$(SRCS_F90:.F90=$(DEPSUF))
DEFS=
lib_LIBRARIES = libhomme_swdgx.a
libhomme_swdgx_a_SOURCES = $(SRCS_F90)	 
include_HEADERS =    			$(SRC_SHARE)/interface.h \
					$(SRC_SHARE)/timer.h

bin_PROGRAMS = 				swdgx
swdgx_SOURCES = 			$(SRC)/dg_main.F90
swdgx_LDADD = 				./libhomme_swdgx.a \
					-L../../utils/pio -lpio \
					-L../../utils/timing -ltiming \
					$(AM_LDFLAGS) \
					$(HOMME_LIBS)


#
# Automatically generated module dependencies
#

depends: $(DEPENDS)
	@echo "Done updating dependencies"
	$(CPP) -DHAVE_CONFIG_H -I.  $(SRC)/dg_main.F90 | $(AWK) -f $(FDEPENDS) -v NAME=$(basename $(notdir $(SRC)/dg_main.F90)) -v SUF=$(suffix $(SRC)/dg_main.F90)  > dg_main.d


%$(DEPSUF): %.F90
		@echo 'Making dependencies for' $< '-->' `basename $@`
		$(CPP) -DHAVE_CONFIG_H -I. -I../../src/share -I ../../src $< | $(AWK) -f $(FDEPENDS) -v NAME=$(basename $(notdir $<)) -v SUF=$(suffix $<)  > `basename $@`

clean-local:
					rm -rf *.mod 

clean-depends:
					rm -rf *.d *~

distclean-local: clean-depends

 -include *.d
