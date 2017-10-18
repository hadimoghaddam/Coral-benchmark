AUTOMAKE_OPTIONS = foreign
# Relevant Directories within the HOMME repository
# holding source files needed for building the library
# and executable for testing the mesh module.
SRC = ../../../src
SRC_SHARE = $(SRC)/share
PHYSICS = ../../../physics
UTILS = ../../../utils/csm_share
INCLUDES =  -I../../../utils/pio -I../../../utils/timing -I../../../src $(HOMME_INCLUDE)
AM_FCFLAGS= $(MY_DEFS)
AM_LDFLAGS = $(LOCAL_BLAS_LOCATION) $(LOCAL_LAPACK_LOCATION) $(HOMME_LDFLAGS)
AM_CFLAGS = -DFORTRANUNDERSCORE -DSPMD

SRCS_F90 = 	                         $(SRC_SHARE)/kinds.F90 \
					$(SRC_SHARE)/dimensions_mod.F90 \
					$(SRC_SHARE)/control_mod.F90 \
					$(SRC_SHARE)/physical_constants.F90 \
					$(SRC_SHARE)/coordinate_systems_mod.F90 \
					$(SRC_SHARE)/params_mod.F90 \
					$(SRC_SHARE)/gridgraph_mod.F90 \
					$(SRC_SHARE)/edge_mod.F90 \
					$(SRC_SHARE)/element_mod.F90 \
					$(SRC_SHARE)/parallel_mod.F90 \
					$(SRC_SHARE)/hybrid_mod.F90 \
					$(SRC_SHARE)/reduction_mod.F90 \
					$(SRC_SHARE)/quadrature_mod.F90 \
					$(SRC_SHARE)/global_norms_mod.F90 \
					$(SRC_SHARE)/ll_mod.F90 \
					$(SRC_SHARE)/metagraph_mod.F90 \
					$(SRC_SHARE)/schedule_mod.F90 \
					$(SRC_SHARE)/thread_mod.F90 \
					$(SRC_SHARE)/bndry_mod.F90 \
					$(SRC_SHARE)/derivative_mod.F90 \
					$(SRC_SHARE)/viscosity_mod.F90 \
					$(SRC_SHARE)/spacecurve_mod.F90 \
					$(SRC_SHARE)/cube_mod.F90 \
					$(SRC_SHARE)/interpolate_mod.F90 \
					$(PHYSICS)/physics_types_mod.F90 \
					$(SRC_SHARE)/dof_mod.F90 \
					$(SRC)/common_io_mod.F90 \
					$(SRC)/pio_io_mod.F90 \
					$(PHYSICS)/physics_io_mod.F90 \
					$(SRC_SHARE)/time_mod.F90 \
					$(PHYSICS)/gravity_wave_drag_mod.F90 \
					$(SRC_SHARE)/physics_mod.F90 \
					$(SRC_SHARE)/hybvcoord_mod.F90 \
					$(SRC)/aquaplanet.F90 \
					$(SRC)/aquaplanet_io_mod.F90 \
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
					$(SRC)/common_movie_mod.F90 \
					$(SRC_SHARE)/cslam_mod.F90 \
					$(SRC_SHARE)/cslam_control_volume_mod.F90 \
					$(SRC_SHARE)/cslam_line_integrals_mod.F90 \
					$(SRC_SHARE)/cslam_analytic_mod.F90 \
					$(SRC_SHARE)/cslam_filter_mod.F90 \
					$(SRC_SHARE)/cslam_reconstruction_mod.F90 \
					$(SRC_SHARE)/namelist_mod.F90 \
					$(SRC_SHARE)/mass_matrix_mod.F90 \
					$(SRC)/checksum_mod.F90 \
					$(SRC)/baroclinic_inst_mod.F90 \
					$(SRC_SHARE)/diffusion_mod.F90 \
					$(SRC_SHARE)/prim_si_mod.F90 \
					$(SRC)/asp_tests.F90 \
					$(SRC_SHARE)/prim_state_mod.F90 \
					$(SRC)/prim_restart_mod.F90 \
					$(SRC_SHARE)/prim_si_ref_mod.F90 \
					$(SRC_SHARE)/prim_advance_mod.F90 \
					$(SRC_SHARE)/prim_advection_mod.F90 \
					$(SRC)/forcing_mod.F90 \
					$(PHYSICS)/emanuel/convect43c.F90 \
					$(PHYSICS)/heldsuarez/held_suarez_mod.F90 \
					$(PHYSICS)/column_model_mod.F90 \
					$(SRC_SHARE)/metis_mod.F90 \
					$(SRC_SHARE)/prim_driver_mod.F90 \
					$(SRC)/vertical_mod.F90 \
					$(PHYSICS)/emanuel/mjo_mod.F90 \
					$(SRC)/prim_movie_mod.F90 \
					$(SRC)/surfaces_mod.F90 \
					$(SRC)/interpolate_driver_mod.F90 \
					$(SRC)/netcdf_io_mod.F90 \
					$(SRC)/repro_sum_mod.F90 \
					$(SRC_SHARE)/mesh_mod.F90

FDEPENDS= ../../../helpers/fdepends.awk
DEPSUF = .d
DEPENDS :=$(SRCS_F90:.F90=$(DEPSUF))
DEFS=
lib_LIBRARIES = libhomme.a
libhomme_a_SOURCES = $(SRCS_F90)	 
include_HEADERS =    			$(SRC_SHARE)/interface.h \
					$(SRC_SHARE)/timer.h

bin_PROGRAMS = 				test_mesh
test_mesh_SOURCES = 			../mesh_mod/main.F90 
test_mesh_LDADD = 		        ./libhomme.a \
					-L../../../utils/pio -lpio \
					-L../../../utils/timing -ltiming \
					$(AM_LDFLAGS) \
					$(HOMME_LIBS)

#
# Automatically generated module dependencies
#

depends: $(DEPENDS)
	@echo "Done updating dependencies"
	$(CPP) -DHAVE_CONFIG_H -I.  ../mesh_mod/main.F90 | $(AWK) -f $(FDEPENDS) -v NAME=$(basename $(notdir ../mesh_mod/main.F90)) -v SUF=$(suffix ../mesh_mod/main.F90)  > main.d


%$(DEPSUF): %.F90
		@echo 'Making dependencies for' $< '-->' `basename $@`
		$(CPP) -DHAVE_CONFIG_H -I. $< | $(AWK) -f $(FDEPENDS) -v NAME=$(basename $(notdir $<)) -v SUF=$(suffix $<)  > `basename $@`


clean-local:
					rm -rf *.mod

clean-depends:
					rm -rf *.d *~

distclean-local: clean-depends

 -include *.d
