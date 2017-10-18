#!/bin/tcsh -f
#
###############################################################
# Restart, and energy conservation test
###############################################################

# start_dir   = reg_test directory (used to copy namelist and vcoord)
set start_dir = $PWD/..
set namelist_dir = namelists/little_endian
if (`uname` == AIX) set namelist_dir = namelists/big_endian

# out_dir = where output will be saved
if ( $?HOMME_OUT ) then
	set out_dir = $HOMME_OUT/preqx/baro2c
	echo Found \$HOMME_OUT, output will be stored in $out_dir
else
	set out_dir = ~/scratch1/reg-test/preqx/baro2c
	echo Did not find \$HOMME_OUT, output will be stored in
	echo $out_dir instead
endif

echo

# bld_dir = $HOMME/build/preqx
if ( ! $?HOMME_ROOT ) then
        set HOMME_ROOT = $PWD/../../..
	echo \$HOMME_ROOT is undefined, using $HOMME_ROOT
else
	if ( ! -d $HOMME_ROOT/build/preqx ) then
		echo $HOMME_ROOT does not contain build system for HOMME,
		set HOMME_ROOT = ~/codes/homme
		echo using $HOMME_ROOT instead
		echo
	endif
endif

if ( -d $HOMME_ROOT/build/preqx ) then
	set bld_dir = $HOMME_ROOT/build/preqx
else
	echo $HOMME_ROOT does not contain build system for HOMME! 
	exit
endif

echo Building from $HOMME_ROOT

set NCPU = 24
if ( ${?PBS_NODEFILE} ) then
   set NCPU = `wc $PBS_NODEFILE | awk '{print $1}' - `
endif
if ( ${?SLURM_NNODES} ) then
   set NCPU = ${SLURM_JOB_NUM_NODES}
   set cores = `echo ${SLURM_TASKS_PER_NODE} | cut -d '(' -f1`
   set MPI_RUN = "mpiexec --npernode $cores numa_wrapper --ppn $cores"
   set MPI_RUN_OMP = "mpiexec --npernode 1"
else
   set MPI_RUN = "mpirun -np $NCPU"
   set NCPU_OMP=1
   if ( $NCPU >= 4 ) then
      @ NCPU_OMP = $NCPU / 4    
   endif
   set MPI_RUN_OMP = "mpirun -np $NCPU_OMP"
endif
echo NCPU = $NCPU

# Configure and Make
# MNL note: don't need to completely clean / rebuild if config.h
#           and dependencies are already set correctly...
cd $bld_dir

# CFG contains flags to use w/ ./configure
set CFG = "--enable-blas --enable-lapack --enable-energy-diagnostics --with-netcdf=$NETCDF_PATH --with-pnetcdf=$PNETCDF_PATH NP=4 PLEV=26"
if ( -e config.status ) then
	echo config.status exists, running it!
	./config.status
	set NP = `sed -n 's/#define NP \([0-9]\)/\1/p' config.log`
	set PLEV = `sed -n 's/#define PLEV \([0-9]\)/\1/p' config.log`
	set PIO = `sed -n 's/#define PIO \([0-9]\)/\1/p' config.log`
	set ENERGY = `sed -n 's/#define ENERGY_DIAGNOSTICS \([0-9]\)/\1/p' config.log`
	echo NP = $NP
	echo PLEV = $PLEV
	echo PIO = $PIO
	echo ENERGY_DIAGNOSTICS = $ENERGY
	if ( ( $NP == 4 ) && ( $PLEV == 26 ) && ( $PIO != 1 ) && ( $ENERGY == 1 ) ) then
		echo Already configured with NP = 4, PLEV = 26, PIO_INTERP, and Energy diagnostics...
		echo Skipping configure stage
		rm -f preqx
		make -j 4
	else
		echo Need to reconfigure / rebuild to change NP, PLEV, and / or enable energy-diagnostics
		make distclean
		./configure $CFG
		make -j4 depends
		make -j 4
	endif
else
	echo No config.status exists, need to configure / build from start
	./configure $CFG
	make -j4 depends
	make -j 4
endif
if ( $status ) exit

# Create directories for output
mkdir -p $out_dir/movies
mkdir -p $out_dir/restart
rm -f $out_dir/restart/R0000*
cp $start_dir/$namelist_dir/baro2c-run1.nl $out_dir/input.nl
cd $out_dir
rsync -a $start_dir/../vcoord/*26* ./vcoord


# Run
$MPI_RUN $bld_dir/preqx < input.nl | tee preqx.out

cp -f $start_dir/$namelist_dir/baro2c-run2.nl $out_dir/input.nl
$MPI_RUN $bld_dir/preqx < input.nl | tee -a preqx.out

# 4 threads:
cp -f $start_dir/$namelist_dir/baro2c-run2-omp.nl $out_dir/input.nl
$MPI_RUN_OMP $bld_dir/preqx < input.nl | tee -a preqx.out




