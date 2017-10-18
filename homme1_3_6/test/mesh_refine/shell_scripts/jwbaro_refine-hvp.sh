#!/bin/tcsh -f
#SBATCH --job-name HOMME_comp-res
#SBATCH -N 48
#SBATCH --account=FY115448

#
#  Shallow water test case 6 "referece" test described in
#  homme/README 
#  Mark Taylor 2010/10
#

# OLD VALUES
# NEED TO BE UPDATED TO ACCOUNT FOR NEW
# VARIABLE VISCOSITY SCHEME
# (divide by 1.5399 for hvp=3)
# (divide by 1.7783 for hvp=4)
# (need a column for hvp=3.32)
#   NE  | nu (hvp 3) | nu (hvp 4) |   dt
# ------+-)----------+------------+-------
#   10  |  2.662e16  |  8.294e16  |    270
#   15  |  7.887e15  |  1.638e16  |    180
#   20  |  3.328e15  |  1.184e15  |    135
#   30  |  9.859e14  |  1.024e15  |     90
#   40  |  4.159e14  |   3.24e14  |   67.5
#   60  |  1.232e14  |    6.4e13  |     45
#   80  |  5.199e13  |  2.025e13  |  33.75
#  120  |  1.541e13  |      4e12  |   22.5
#  160  |  6.499e12  |  1.266e12  | 16.875
#  240  |  1.926e12  |    2.5e11  |  11.25
# ------+------------+------------+-------

set NCPU = 16
if ( ${?PBS_NODEFILE} ) then
   set NCPU = `wc $PBS_NODEFILE | awk '{print $1}' - `
endif
echo NCPU = $NCPU

set hypervis_power = 4.0d0

set NE=15
set ref=2
set smth=0
@ NEfine = $NE * $ref

if ($NEfine == 10) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 2.662e16
	if ( ${hypervis_power} == 4.0d0 ) set nu = 4.664e16
	set tstep = 270
endif
if ($NEfine == 15) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 7.887e15
	if ( ${hypervis_power} == 4.0d0 ) set nu = 9.213e15
	set tstep = 180
endif
if ($NEfine == 20) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 3.328e15
	if ( ${hypervis_power} == 4.0d0 ) set nu = 6.289e14
	set tstep = 135
endif
if ($NEfine == 30) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 9.859e14
	if ( ${hypervis_power} == 4.0d0 ) set nu = 5.758e14 
	set tstep = 90
endif
if ($NEfine == 40) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 4.159e14
	if ( ${hypervis_power} == 4.0d0 ) set nu = 1.822e14
	set tstep = 67.5
endif
if ($NEfine == 60) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 1.232e14
	if ( ${hypervis_power} == 4.0d0 ) set nu = 3.599e13
	set tstep = 45
endif
if ($NEfine == 80) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 5.199e13
	if ( ${hypervis_power} == 4.0d0 ) set nu = 1.139e13
	set tstep = 33.75
endif
if ($NEfine == 120) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 1.541e13
	if ( ${hypervis_power} == 4.0d0 ) set nu = 2.249e12
	set tstep = 22.5
endif
if ($NEfine == 160) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 6.499e12
	if ( ${hypervis_power} == 4.0d0 ) set nu = 7.119e11
	set tstep = 16.875
endif
if ($NEfine == 240) then
	if ( ${hypervis_power} == 3.0d0 ) set nu = 1.926e12
	if ( ${hypervis_power} == 4.0d0 ) set nu = 1.405e11
	set tstep = 11.25
endif

if ($ref != 1) then
		set mesh = north_${NE}_x${ref}
	if ($smth != 0) then
		set mesh = ${mesh}_s${smth}
	endif
else
	set mesh = uniform_${NE}
endif

if ( -e ./grids/$mesh.g ) then
	set meshfile = $mesh.g
else
	echo Can not find grids/$mesh.g
	exit
endif
echo Using $meshfile

set wdir = ~/scratch1/comp-res/jw_baro
set input = $PWD
set src = $input/../../build/preqx

set test_case = jw_baroclinic
set NE = 0
set rk_stage=0
set LFTfreq = 1
set integration = explicit
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
endif

# Build
set CFG = "--enable-lapack --enable-blas --enable-mesh-refine PLEV=26 NP=4 --with-netcdf=$NETCDF_PATH --with-pnetcdf=$PNETCDF_PATH"
cd $src
if ( -e config.status ) then
	echo config.status exists, running it!
	./config.status
	set NP = `sed -n 's/#define NP \([0-9]\)/\1/p' config.log`
	set PLEV = `sed -n 's/#define PLEV \([0-9]\)/\1/p' config.log`
	set PIO = `sed -n 's/#define PIO \([0-9]\)/\1/p' config.log`
	set EXO = `sed -n 's/#define MESH \([0-9]\)/\1/p' config.log`
	echo NP = $NP
	echo PLEV = $PLEV
	echo PIO = $PIO
	echo EXODUS = $EXO
	if ( ( $NP == 4 ) && ( $PLEV == 26 ) && ( $PIO != 1 ) && ( $EXO == 1) ) then
		echo Already configured with NP = 4, PLEV = 26, PIO_INTERP, and Exodus meshes...
		echo Skipping configure stage
		rm -f preqx
		make -j 4
	else
		echo Need to reconfigure / rebuild to change NP, PLEV, or PIO
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

# Create directories
set wdir = $wdir/$name
echo wdir = $wdir
mkdir -p $wdir/movies
cd $wdir
cp $input/grids/${meshfile} . 
rsync -a $input/../vcoord/*26* ./vcoord

# Update namelist
sed s/ne=.\*/"ne = $NE"/  $input/namelists/jw_baro.nl |\
sed s/tstep.\*/"tstep = $tstep"/  |\
sed s/fine_ne.\*/"fine_ne = ${NEfine}"/  |\
sed s/limiter_option.\*/"limiter_option = $limiter"/  |\
sed s/test_case.\*/"test_case = \'$test_case\'"/  |\
sed s/integration.\*/"integration = '$integration'"/  |\
sed s/rk_stage_user.\*/"rk_stage_user = $rk_stage"/  |\
sed s/LFTfreq.\*/"LFTfreq = $LFTfreq"/  |\
sed s/nu=.\*/"nu= $nu"/  |\
sed s/nu_s=.\*/"nu_s= $nu_s"/  |\
sed s/filter_freq.\*/"filter_freq = $filter_freq"/  |\
sed s/hypervis_subcycle.\*/"hypervis_subcycle = $hypervis_subcycle"/  |\
sed s/hypervis_power.\*/"hypervis_power = $hypervis_power"/  |\
sed s/mesh_file.\*/"mesh_file = '${meshfile}'"/ |\
sed s/statefreq.\*/"statefreq = $sfreq"/  |\
sed s/nlon.\*/"nlon = $NLON"/  |\
sed s/nlat.\*/"nlat = $NLAT"/  \
> jw_baro.nl

# Run!
date | tee preqx.out
#rm -f movies/swtc5?.nl
mpirun -np $NCPU $src/preqx < jw_baro.nl | tee -a preqx.out
date | tee -a preqx.out


