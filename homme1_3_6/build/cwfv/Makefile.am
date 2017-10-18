AUTOMAKE_OPTIONS = foreign
# Relevant Directories within the HOMME repository
# holding source files needed for building the library
# and executable cwfv.

SRC = ../../src
SRC_SHARE = $(SRC)/share
UTILS = ../../utils/csm_share
INCLUDES =  -I../../utils/pio -I../../utils/timing -I ../../src $(HOMME_INCLUDE)
AM_FCFLAGS= $(MY_DEFS)
AM_LDFLAGS = $(LOCAL_BLAS_LOCATION) $(LOCAL_LAPACK_LOCATION) $(HOMME_LDFLAGS)


SRCS_F90=   		$(SRC_SHARE)/bndry_mod.F90 \
			$(SRC_SHARE)/cslam_mod.F90 \
			$(SRC)/cwfv_bench_mod.F90 \
			$(SRC_SHARE)/cslam_analytic_mod.F90 \
			$(SRC)/cslam_bsp_mod.F90 \
			$(SRC)/cslam_config_mod.F90 \
			$(SRC_SHARE)/cslam_control_volume_mod.F90 \
			$(SRC_SHARE)/cslam_filter_mod.F90 \
			$(SRC)/cslam_ghostcell_mod.F90 \
			$(SRC)/cslam_init_mod.F90 \
			$(SRC_SHARE)/cslam_reconstruction_mod.F90 \
			$(SRC_SHARE)/cslam_line_integrals_mod.F90 \
			$(SRC)/cslam_transformation_mod.F90 \
		        $(SRC_SHARE)/cg_mod.F90 \
		        $(SRC)/checksum_mod.F90 \
		        $(SRC)/netcdf_io_mod.F90 \
		        $(SRC)/common_movie_mod.F90 \
		        $(SRC)/common_io_mod.F90 \
		        $(SRC_SHARE)/control_mod.F90 \
		        $(SRC_SHARE)/coordinate_systems_mod.F90 \
		        $(SRC_SHARE)/cube_mod.F90 \
		        $(SRC_SHARE)/derivative_mod.F90 \
	          	$(SRC_SHARE)/dimensions_mod.F90 \
	          	$(SRC_SHARE)/dof_mod.F90 \
	          	$(SRC_SHARE)/domain_mod.F90 \
		        $(SRC_SHARE)/edge_mod.F90 \
		  	$(SRC_SHARE)/element_mod.F90 \
		        $(SRC_SHARE)/gridgraph_mod.F90 \
		        $(SRC_SHARE)/hybrid_mod.F90 \
			$(SRC)/interp_movie_mod.F90 \
			$(SRC)/netcdf_io_mod.F90 \
			$(SRC)/shal_movie_mod.F90 \
			$(SRC_SHARE)/interpolate_mod.F90 \
			$(SRC_SHARE)/kinds.F90 \
			$(SRC_SHARE)/ll_mod.F90 \
			$(SRC_SHARE)/mass_matrix_mod.F90 \
		        $(SRC_SHARE)/metagraph_mod.F90 \
		        $(SRC_SHARE)/metis_mod.F90 \
		        $(SRC_SHARE)/mesh_mod.F90 \
		        $(SRC_SHARE)/namelist_mod.F90 \
		        $(SRC)/netcdf_io_mod.F90 \
		        $(SRC_SHARE)/parallel_mod.F90 \
		        $(SRC_SHARE)/params_mod.F90 \
		        $(SRC_SHARE)/physical_constants.F90 \
		        $(SRC_SHARE)/quadrature_mod.F90 \
		        $(SRC_SHARE)/reduction_mod.F90 \
		        $(SRC)/repro_sum_mod.F90 \
		        $(SRC)/restart_mod.F90 \
		        $(SRC)/restart_io_mod.F90 \
		        $(SRC_SHARE)/schedule_mod.F90 \
		        $(SRC_SHARE)/spacecurve_mod.F90 \
		        $(SRC)/surfaces_mod.F90 \
		        $(SRC)/state_mod.F90 \
			      $(SRC)/repro_sum_mod.F90 \
		        $(SRC_SHARE)/thread_mod.F90 \
		        $(SRC_SHARE)/time_mod.F90 \
		        $(SRC_SHARE)/viscosity_mod.F90 \
		        $(SRC_SHARE)/global_norms_mod.F90 \
		        $(SRC)/pio_io_mod.F90 \
		        $(UTILS)/shr_kind_mod.F90 \
        		$(UTILS)/shr_mpi_mod.F90 \
        		$(UTILS)/shr_sys_mod.F90 \
        		$(UTILS)/shr_file_mod.F90 \
        		$(UTILS)/shr_vmath_mod.F90 

FDEPENDS=../../helpers/fdepends.awk
DEPSUF = .d
DEPENDS :=$(SRCS_F90:.F90=$(DEPSUF))
DEFS=
lib_LIBRARIES = libhomme_cwfv.a
libhomme_cwfv_a_SOURCES = $(SRCS_F90)	 
include_HEADERS =    			$(SRC_SHARE)/interface.h \
					$(SRC_SHARE)/timer.h

bin_PROGRAMS = 				cwfv
cwfv_SOURCES = 			$(SRC)/cwfv_main.F90
cwfv_LDADD = 				./libhomme_cwfv.a \
					-L../../utils/pio -lpio \
					-L../../utils/timing -ltiming \
					$(AM_LDFLAGS) \
					$(HOMME_LIBS)


#
# Automatically generated module dependencies
#

depends: $(DEPENDS)
	@echo "Done updating dependencies"
	$(CPP) -DHAVE_CONFIG_H -I.  $(SRC)/cwfv_main.F90 | $(AWK) -f $(FDEPENDS) -v NAME=$(basename $(notdir $(SRC)/cwfv_main.F90)) -v SUF=$(suffix $(SRC)/cwfv_main.F90)  > cwfv_main.d


%$(DEPSUF): %.F90
		@echo 'Making dependencies for' $< '-->' `basename $@`
		$(CPP) -DHAVE_CONFIG_H -I. $< | $(AWK) -f $(FDEPENDS) -v NAME=$(basename $(notdir $<)) -v SUF=$(suffix $<)  > `basename $@`

clean-local:
					rm -rf *.mod 

clean-depends:
					rm -rf *.d *~

distclean-local: clean-depends

 -include *.d