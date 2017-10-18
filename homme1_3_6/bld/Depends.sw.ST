main.o : main.F90 control_mod.o perf_mod.o reduction_mod.o edge_mod.o element_mod.o domain_mod.o dimensions_mod.o thread_mod.o parallel_mod.o sweq_mod.o init_mod.o 
perf_utils.o : perf_utils.F90 gptl.inc 
perf_mod.o : perf_mod.F90 gptl.inc perf_utils.o 
shr_kind_mod.o : shr_kind_mod.F90 
shr_mpi_mod.o : shr_mpi_mod.F90 shr_kind_mod.o 
shr_sys_mod.o : shr_sys_mod.F90 shr_mpi_mod.o shr_kind_mod.o 
shr_file_mod.o : shr_file_mod.F90 shr_sys_mod.o shr_kind_mod.o 
shr_vmath_mod.o : shr_vmath_mod.F90 shr_kind_mod.o 
reduction_mod.o : reduction_mod.F90 parallel_mod.o dimensions_mod.o hybrid_mod.o kinds.o 
edge_mod.o : edge_mod.F90 coordinate_systems_mod.o control_mod.o dimensions_mod.o kinds.o 
element_mod.o : element_mod.F90 gridgraph_mod.o edge_mod.o dimensions_mod.o coordinate_systems_mod.o kinds.o 
domain_mod.o : domain_mod.F90 perf_mod.o 
dimensions_mod.o : dimensions_mod.F90 
thread_mod.o : thread_mod.F90 
parallel_mod.o : parallel_mod.F90 dimensions_mod.o kinds.o 
control_mod.o : control_mod.F90 kinds.o 
restart_io_mod.o : restart_io_mod.F90 schedule_mod.o control_mod.o element_mod.o time_mod.o parallel_mod.o perf_mod.o dimensions_mod.o kinds.o 
cg_mod.o : cg_mod.F90 parallel_mod.o reduction_mod.o hybrid_mod.o dimensions_mod.o kinds.o 
solver_mod.o : solver_mod.F90 parallel_mod.o linear_algebra_mod.o bndry_mod.o physical_constants.o control_mod.o derivative_mod.o edge_mod.o cg_mod.o reduction_mod.o element_mod.o perf_mod.o dimensions_mod.o kinds.o 
filter_mod.o : filter_mod.F90 quadrature_mod.o perf_mod.o dimensions_mod.o kinds.o 
quadrature_mod.o : quadrature_mod.F90 physical_constants.o kinds.o 
global_norms_mod.o : global_norms_mod.F90 control_mod.o quadrature_mod.o parallel_mod.o reduction_mod.o physical_constants.o dimensions_mod.o element_mod.o hybrid_mod.o kinds.o 
derivative_mod.o : derivative_mod.F90 element_mod.o physical_constants.o quadrature_mod.o dimensions_mod.o kinds.o 
time_mod.o : time_mod.F90 kinds.o 
hybrid_mod.o : hybrid_mod.F90 parallel_mod.o 
physical_constants.o : physical_constants.F90 kinds.o 
kinds.o : kinds.F90 
namelist_mod.o : namelist_mod.F90 common_movie_mod.o common_io_mod.o interpolate_mod.o cg_mod.o parallel_mod.o time_mod.o dimensions_mod.o thread_mod.o control_mod.o cube_mod.o params_mod.o kinds.o 
cube_mod.o : cube_mod.F90 parallel_mod.o spacecurve_mod.o gridgraph_mod.o params_mod.o control_mod.o quadrature_mod.o dimensions_mod.o element_mod.o physical_constants.o coordinate_systems_mod.o kinds.o 
spacecurve_mod.o : spacecurve_mod.F90 gridgraph_mod.o dimensions_mod.o kinds.o 
metagraph_mod.o : metagraph_mod.F90 ll_mod.o gridgraph_mod.o kinds.o 
schedule_mod.o : schedule_mod.F90 gridgraph_mod.o parallel_mod.o dimensions_mod.o element_mod.o kinds.o metagraph_mod.o 
mass_matrix_mod.o : mass_matrix_mod.F90 bndry_mod.o edge_mod.o parallel_mod.o element_mod.o quadrature_mod.o dimensions_mod.o kinds.o 
dof_mod.o : dof_mod.F90 coordinate_systems_mod.o bndry_mod.o edge_mod.o parallel_mod.o element_mod.o quadrature_mod.o dimensions_mod.o kinds.o 
bndry_mod.o : bndry_mod.F90 dimensions_mod.o hybrid_mod.o parallel_mod.o thread_mod.o schedule_mod.o edge_mod.o kinds.o 
gridgraph_mod.o : gridgraph_mod.F90 dimensions_mod.o params_mod.o control_mod.o kinds.o 
perfmodel_mod.o : perfmodel_mod.F90 kinds.o 
viscosity_mod.o : viscosity_mod.F90 global_norms_mod.o physical_constants.o bndry_mod.o edge_mod.o derivative_mod.o element_mod.o hybrid_mod.o dimensions_mod.o kinds.o 
coordinate_systems_mod.o : coordinate_systems_mod.F90 physical_constants.o kinds.o 
ll_mod.o : ll_mod.F90 
metis_mod.o : metis_mod.F90 params_mod.o control_mod.o dimensions_mod.o parallel_mod.o gridgraph_mod.o kinds.o 
params_mod.o : params_mod.F90 
linear_algebra_mod.o : linear_algebra_mod.F90 parallel_mod.o kinds.o 
checksum_mod.o : checksum_mod.F90 dimensions_mod.o schedule_mod.o kinds.o bndry_mod.o edge_mod.o gridgraph_mod.o parallel_mod.o element_mod.o 
common_movie_mod.o : common_movie_mod.F90 time_mod.o common_io_mod.o control_mod.o 
common_io_mod.o : common_io_mod.F90 parallel_mod.o control_mod.o 
netcdf_io_mod.o : netcdf_io_mod.F90 common_io_mod.o control_mod.o parallel_mod.o kinds.o 
interp_movie_mod.o : interp_movie_mod.F90 perf_mod.o viscosity_mod.o derivative_mod.o physical_constants.o parallel_mod.o element_mod.o hybrid_mod.o time_mod.o common_io_mod.o control_mod.o pio_io_mod.o interpolate_mod.o dimensions_mod.o kinds.o 
pio_io_mod.o : pio_io_mod.F90 control_mod.o common_io_mod.o parallel_mod.o kinds.o 
interpolate_mod.o : interpolate_mod.F90 reduction_mod.o hybrid_mod.o cube_mod.o parallel_mod.o physical_constants.o coordinate_systems_mod.o quadrature_mod.o dimensions_mod.o element_mod.o kinds.o 
state_mod.o : state_mod.F90 reduction_mod.o element_mod.o hybrid_mod.o dimensions_mod.o kinds.o 
init_mod.o : init_mod.F90 perf_mod.o params_mod.o restart_mod.o restart_io_mod.o dof_mod.o spacecurve_mod.o checksum_mod.o metis_mod.o parallel_mod.o state_mod.o schedule_mod.o gridgraph_mod.o metagraph_mod.o reduction_mod.o edge_mod.o cube_mod.o mass_matrix_mod.o element_mod.o quadrature_mod.o time_mod.o dimensions_mod.o namelist_mod.o control_mod.o thread_mod.o kinds.o 
shallow_water_mod.o : shallow_water_mod.F90 control_mod.o viscosity_mod.o common_io_mod.o parallel_mod.o hybrid_mod.o element_mod.o time_mod.o global_norms_mod.o quadrature_mod.o coordinate_systems_mod.o bndry_mod.o edge_mod.o derivative_mod.o dimensions_mod.o physical_constants.o kinds.o 
sweq_mod.o : sweq_mod.F90 types_mod.o rk_mod.o perf_mod.o control_mod.o advance_mod.o restart_io_mod.o cg_mod.o solver_mod.o filter_mod.o state_mod.o element_mod.o reduction_mod.o edge_mod.o quadrature_mod.o global_norms_mod.o shal_movie_mod.o shallow_water_mod.o dimensions_mod.o derivative_mod.o time_mod.o hybrid_mod.o thread_mod.o parallel_mod.o physical_constants.o kinds.o 
restart_mod.o : restart_mod.F90 restart_io_mod.o element_mod.o parallel_mod.o dimensions_mod.o kinds.o 
advance_mod.o : advance_mod.F90 solver_mod.o types_mod.o perf_mod.o global_norms_mod.o viscosity_mod.o bndry_mod.o cg_mod.o shallow_water_mod.o control_mod.o time_mod.o derivative_mod.o reduction_mod.o hybrid_mod.o filter_mod.o edge_mod.o element_mod.o physical_constants.o dimensions_mod.o kinds.o 
shal_movie_mod.o : shal_movie_mod.F90 physical_constants.o common_movie_mod.o dof_mod.o netcdf_io_mod.o common_io_mod.o derivative_mod.o coordinate_systems_mod.o element_mod.o control_mod.o time_mod.o parallel_mod.o hybrid_mod.o dimensions_mod.o kinds.o 
types_mod.o : types_mod.F90 kinds.o 
rk_mod.o : rk_mod.F90 physical_constants.o reduction_mod.o types_mod.o kinds.o hybrid_mod.o element_mod.o dimensions_mod.o 
