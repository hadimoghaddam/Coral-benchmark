#!/bin/tcsh -f
#
###############################################################
#
# Spectral Element -- 9 days of ASP baroclinic test
# (Jablonowski and Williamson test + 4 tracers)
# NE=15, dt=180, nu=1e16, filter_freq=0, NP=4, PLEV=26
# (explicit leap-frog)
#
###############################################################

# start_dir   = reg_test directory (used to copy namelist, ncl, vcoord)
set start_dir = $PWD/..
set namelist_dir = namelists/little_endian
if (`uname` == AIX) set namelist_dir = namelists/big_endian

# out_dir = where output will be saved
if ( $?HOMME_OUT ) then
	set out_dir = $HOMME_OUT/preqx/baro2a
	echo Found \$HOMME_OUT, output will be stored in $out_dir
else
	set out_dir = ~/scratch1/reg-test/preqx/baro2a
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
   set cores = 8
   set MPI_RUN = "mpiexec --npernode $cores numa_wrapper --ppn $cores"
else
	set MPI_RUN = "mpirun -np $NCPU"
endif
echo NCPU = $NCPU

# Configure and Make
# MNL note: don't need to completely clean / rebuild if config.h
#           and dependencies are already set correctly...
cd $bld_dir

# CFG contains flags to use w/ ./configure

#set CFG = "--enable-blas --enable-lapack --with-netcdf=$NETCDF_PATH --with-pnetcdf=$PNETCDF_PATH NP=4 PLEV=26"
#if ( -e config.status ) then
#	echo config.status exists, running it!
#	./config.status
#	set NP = `sed -n 's/#define NP \([0-9]\)/\1/p' config.log`
#	set PLEV = `sed -n 's/#define PLEV \([0-9]\)/\1/p' config.log`
#	set PIO = `sed -n 's/#define PIO \([0-9]\)/\1/p' config.log`
#	echo NP = $NP
#	echo PLEV = $PLEV
#	echo PIO = $PIO
#	if ( ( $NP == 4 ) && ( $PLEV == 26 )  && ( $PIO != 1 )) then
#		echo Already configured with NP = 4, PLEV = 26, and PIO_INTERP...
#		echo Skipping configure stage
#		rm -f preqx
#		make -j 4
#	else
#		echo Need to reconfigure / rebuild to change NP and PLEV
#		make distclean
#		./configure $CFG
#		make depends
#		make -j 4
#	endif
#else
#	echo No config.status exists, need to configure / build from start
#	./configure $CFG
#	make depends
#	make -j 4
#endif

# Create directories for output
mkdir -p $out_dir/movies
cp $start_dir/$namelist_dir/baro2a.nl $out_dir/input.nl
cd $out_dir
rsync -a $start_dir/../vcoord/*26* ./vcoord
rm -f baro2.ncl
ln -s $start_dir/ncl/baro2.ncl ./


# Run
date
$MPI_RUN $bld_dir/preqx < input.nl | tee preqx.out
date
ncl baro2.ncl | tee -a preqx.out
