#!/bin/tcsh -f
#SBATCH --job-name HOMME_comp-res
#SBATCH -N 48
#SBATCH --account=FY115448

#
#  Mesh Refinement for shallow water
#  Not meant for swtc1 (which is inviscid, bigger time step)
#  Mike Levy 2011/05

# User settings: testcase, coarse resolution, amount of refinement, amount of smoothing
set test_case = swtc1
if ("$test_case" == "swtc1") then
	set refine = "equator"
	set ndays = 12
else if ("$test_case" == "swtc2") then
	set refine = "quadrant"
	set ndays = 5
else if ("$test_case" == "swtc5") then
	set refine = "mountain"
	set ndays = 15
else
	echo Script is meant for swtc1, swtc2, or swtc5... $test_case is invalid!
	exit
endif

set NE=20
set ref=2
set smth=0

set mesh = ${refine}_${NE}_x${ref}
if ( $smth != 0 ) then
	set mesh = $mesh-s${smth}
endif
if ($ref != 1) then
	if ($smth != 0) then
		set mesh = $mesh-smth_${smth}
	endif
endif

if ( -e ./grids/$mesh.g ) then
	set meshfile = $mesh.g
else
	echo Can not find grids/$mesh.g
	echo Error: Can not determine mesh file!
	exit
endif
echo Using $meshfile

set NCPU = 64
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

set start_dir = $PWD

# out_dir = where output will be saved
if ( $?HOMME_OUT ) then
	set out_dir = $HOMME_OUT/${test_case}
	echo Found \$HOMME_OUT, output will be stored in $out_dir
else
	set out_dir = ~/scratch1/comp-res/${test_case}
	echo Did not find \$HOMME_OUT, output will be stored in
	echo $out_dir instead
endif

echo

# bld_dir = $HOMME/build/sweqx
if ( ! $?HOMME_ROOT ) then
	set HOMME_ROOT = ~/codes/homme
	echo \$HOMME_ROOT is undefined, using $HOMME_ROOT
else
	if ( ! -d $HOMME_ROOT/build/sweqx ) then
		echo $HOMME_ROOT does not contain build system for HOMME,
		set HOMME_ROOT = ~/codes/homme
		echo using $HOMME_ROOT instead
		echo
	endif
endif

if ( -d $HOMME_ROOT/build/sweqx ) then
	set bld_dir = $HOMME_ROOT/build/sweqx
else
	echo $HOMME_ROOT does not contain build system for HOMME! 
	exit
endif

echo Building from $HOMME_ROOT

#   NE  |     nu    |    dt
# ------+-----------+-------
#   10  | 8.2944e16 |    200
#   12  |      4e16 |    120
#   15  | 1.6384e16 |     80
#   20  |  5.184e15 |     50
#   30  |  1.024e15 |     20
#   40  |   3.24e14 |   12.5
#   60  |    6.4e13 |      5
#   80  |  2.025e13 |  3.125
#  120  |      4e12 |   1.28
#  160  | 1.2657e12 |   0.75
#  240  |    2.5e11 |   0.32
# --------------------------
@ NEfine = $NE * $ref
# Set nu based on coarse grid
if ($NE == 10) then
	set nu = 8.2944e16
endif
if ($NE == 12) then
	set nu = 4e16
endif
if ($NE == 15) then
	set nu = 1.6384e16
endif
if ($NE == 20) then
	set nu = 5.184e15
endif
if ($NE == 30) then
	set nu = 1.024e15
endif
if ($NE == 40) then
	set nu = 3.24e14
endif
if ($NE == 60) then
	set nu = 6.4e13
endif
if ($NE == 80) then
	set nu = 2.025e13
endif
if ($NE == 160) then
	set nu = 1.2657e12
endif

if ( "$test_case" == "swtc1" ) then
	set nu = 0
endif

# set dt based on fine grid
if ($NEfine == 10) then
	set tstep = 200
endif
if ($NEfine == 12) then
	set tstep = 120
endif
if ($NEfine == 15) then
	set tstep = 80
endif
if ($NEfine == 20) then
	set tstep = 50
endif
if ($NEfine == 30) then
	set tstep = 20
endif
if ($NEfine == 40) then
	if ( "$test_case" == "swtc1" ) then
		set tstep = 37.5
	else
		set tstep = 12.5
	endif
endif
if ($NEfine == 60) then
	if ( "$test_case" == "swtc1" ) then
		set tstep = 15
	else
		set tstep = 5
	endif
endif
if ($NEfine == 80) then
	if ( "$test_case" == "swtc1" ) then
		set tstep = 9.125
	else
		set tstep = 3.125
	endif
endif
if ($NEfine == 120) then
	if ( "$test_case" == "swtc1" ) then
		set tstep = 3.84
	else
		set tstep = 1.28
	endif
endif
if ($NEfine == 160) then
	if ( "$test_case" == "swtc1" ) then
		set tstep = 2.25
	else
		set tstep = 0.75
	endif
endif
if ($NEfine == 240) then
	if ( "$test_case" == "swtc1" ) then
		set tstep = 0.96
	else
		set tstep = 0.32
	endif
endif

if ( ( "$test_case" == "swtc1" ) && ( $NEfine < 40 ) ) then
	@ tstep = ( $tstep * 3 )
endif

set hypervis_power = 4.0d0
set hypervis_basis_parameter = 0


set NE = 0
set rk_stage=0
set LFTfreq = 1
set integration = explicit
set smooth = 0
set limiter = 0
set filter_freq = 0
set sfreq = 12
set hypervis_subcycle =  1
set nu_s = 0
@ sfreq *= 3600
set sfreq = `echo "$sfreq / $tstep" | bc`
set NLON=720
set NLAT=360

set name = ${mesh}-dt${tstep}-nu${nu}
if (${hypervis_subcycle} != 1) then
	set name = ${name}-sub${hypervis_subcycle}
endif
if (${hypervis_power} != 0) then
	set name = ${name}-hvp${hypervis_power}
	if (${hypervis_basis_parameter}  != 0) then
		set name = ${name}-edge
	else
		set name = ${name}-area
	endif
endif
set out_dir = $out_dir/$name
mkdir -p $out_dir/movies
# Configure and Make
# MNL note: don't need to completely clean / rebuild if config.h
#           and dependencies are already set correctly...
cd $bld_dir

# CFG contains flags to use w/ ./configure
if ( "$test_case" == "swtc1" ) then
	set PLEVin = 4
else
	set PLEVin = 1
endif
set CFG = "--enable-blas --enable-lapack --enable-mesh-refine --with-netcdf=$NETCDF_PATH --with-pnetcdf=$PNETCDF_PATH NP=4 PLEV=$PLEVin"
if ( -e config.status ) then
	echo config.status exists, running it!
	./config.status
	set NP = `sed -n 's/#define NP \([0-9]\)/\1/p' config.log`
	set PLEV = `sed -n 's/#define PLEV \([0-9]\)/\1/p' config.log`
	set PIO = `sed -n 's/#define PIO \([0-9]\)/\1/p' config.log`
	set EXODUS = `sed -n 's/#define EXODUS \([0-9]\)/\1/p' config.log`
	echo NP = $NP
	echo PLEV = $PLEV
	echo PIO = $PIO
	echo EXODUS = $EXODUS
	if ( ( $NP == 4 ) && ( $PLEV == $PLEVin ) && ( $PIO != 1 ) && ( $EXODUS == 1 ) ) then
		echo Already configured with NP = 4, PLEV = $PLEVin, PIO_INTERP, and mesh-refine...
		echo Skipping configure stage
		rm -f sweqx
		make -j 4
	else
		echo Need to reconfigure / rebuild to change NP and PLEV
		make distclean
		./configure $CFG
		make depends
		make -j 4
	endif
else
	echo No config.status exists, need to configure / build from start
	./configure $CFG
	make depends
	make -j 4
endif

cd $out_dir
cp $start_dir/grids/${meshfile} . 

# Update namelist
sed s/ne=.\*/"ne = $NE"/  $start_dir/namelists/shallow.nl |\
sed s/tstep.\*/"tstep = $tstep"/  |\
sed s/^ndays.\*/"ndays = $ndays"/  |\
sed s/limiter_option.\*/"limiter_option = $limiter"/  |\
sed s/smooth.\*/"smooth = $smooth"/  |\
sed s/test_case.\*/"test_case = \'$test_case\'"/  |\
sed s/integration.\*/"integration = '$integration'"/  |\
sed s/rk_stage_user.\*/"rk_stage_user = $rk_stage"/  |\
sed s/LFTfreq.\*/"LFTfreq = $LFTfreq"/  |\
sed s/nu=.\*/"nu= $nu"/  |\
sed s/nu_s=.\*/"nu_s= $nu_s"/  |\
sed s/filter_freq.\*/"filter_freq = $filter_freq"/  |\
sed s/hypervis_subcycle.\*/"hypervis_subcycle = $hypervis_subcycle"/  |\
sed s/hypervis_power.\*/"hypervis_power = $hypervis_power"/  |\
sed s/hypervis_basis_parameter.\*/"hypervis_basis_parameter = $hypervis_basis_parameter"/  |\
sed s/exodus.\*/"exodus_mesh_file = '${meshfile}'"/ |\
sed s/statefreq.\*/"statefreq = $sfreq"/  |\
sed s/nlon.\*/"nlon = $NLON"/  |\
sed s/nlat.\*/"nlat = $NLAT"/  \
> input.nl

# Run!
date
rm -f movies/swtc??.nl
$MPI_RUN $bld_dir/sweqx < input.nl | tee  sweqx.out
date

# Generate gridplots.pdf
rm -f swtc5.ncl
if (${test_case} == swtc5) then
	ln -s $start_dir/ncl/swtc5ref.ncl ./swtc5.ncl
	ncl swtc5.ncl | tee -a sweqx.out
endif


