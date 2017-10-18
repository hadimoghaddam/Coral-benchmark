#!/bin/tcsh -f
#SBATCH --job-name HOMME_comp-res
#SBATCH -N 48
#SBATCH --account=FY115448

#
#  Polvani primitive eq test case 6
#  Testing with mesh refinement in northern hemisphere
#  Mike Levy 2011/05
#

#   NE  |  dt
# ------+-----
#   10  |  270
#   15  |  180
#   20  |  135
#   30  |   90
#   40  | 67.5
#   60  |   45
#   80  | 3.75
#  120  | 22.5
#  160  | .875
#  240  | 1.25
# ------+-----

set NCPU = 32
if ( ${?PBS_NODEFILE} ) then
   set NCPU = `wc $PBS_NODEFILE | awk '{print $1}' - `
endif
echo NCPU = $NCPU
set START=$PWD

set NE=15
set ref=2
set smth=0
@ NEfine = $NE * $ref

if ($NEfine == 10) then
	set tstep = 270
endif
if ($NEfine == 15) then
	set tstep = 180
endif
if ($NEfine == 20) then
	set tstep = 135
endif
if ($NEfine == 30) then
	#set tstep = 90
	set tstep = 60
endif
if ($NEfine == 40) then
	set tstep = 67.5
endif
if ($NEfine == 60) then
	set tstep = 45
endif
if ($NEfine == 80) then
	set tstep = 33.75
endif
if ($NEfine == 120) then
	set tstep = 22.5
endif
if ($NEfine == 160) then
	set tstep = 16.875
endif
if ($NEfine == 240) then
	set tstep = 11.25
endif

if ($ref != 1) then
		set mesh = north_${NE}_x${ref}
	if ($smth != 0) then
		set mesh = ${mesh}-s${smth}
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

set wdir = ~/scratch1/comp-res/polvani_baro
set input = $PWD
set src = $input/../../build/preqx

set test_case = baroclinic
set NE = 0
set sfreq = 12
@ sfreq *= 3600
set sfreq = `echo "$sfreq / $tstep" | bc`

# Build
# CFG contains flags to use w/ ./configure
set CFG="--enable-lapack --enable-blas --enable-mesh-refine PLEV=20 NP=4 --with-netcdf=$NETCDF_PATH --with-pnetcdf=$PNETCDF_PATH"
cd $src
if ( -e config.status ) then
	echo config.status exists, running it!
	./config.status
	set NP = `sed -n 's/#define NP \([0-9]\)/\1/p' config.log`
	set PLEV = `sed -n 's/#define PLEV \([0-9]\)/\1/p' config.log`
	set PIO = `sed -n 's/#define PIO \([0-9]\)/\1/p' config.log`
	set EXO = `sed -n 's/#define EXODUS \([0-9]\)/\1/p' config.log`
	echo NP = $NP
	echo PLEV = $PLEV
	echo PIO = $PIO
	echo EXODUS = $EXO
	if ( ( $NP == 4 ) && ( $PLEV == 20 ) && ( $PIO != 1 ) && ( $EXO == 1) ) then
		echo Already configured with NP = 4, PLEV = 20, PIO_INTERP, and Exodus meshes...
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
set name = ${mesh}-dt${tstep}
set wdir = $wdir/$name
mkdir -p $wdir/movies
cd $wdir
cp $input/grids/${meshfile} . 
rsync -a $input/../vcoord/*20* ./vcoord
rm -f makeplots.ncl
ln -s $START/ncl/polvani_north.ncl ./makeplots.ncl

# Update namelist
sed s/ne=.\*/"ne = $NE"/  $input/namelists/polvani_baro.nl |\
sed s/tstep.\*/"tstep = $tstep"/  |\
sed s/exodus.\*/"exodus_mesh_file = '${meshfile}'"/ |\
sed s/statefreq.\*/"statefreq = $sfreq"/  \
> polvani_baro.nl

# Run!
date | tee preqx.out
#rm -f movies/swtc5?.nl
mpirun -np $NCPU $src/preqx < polvani_baro.nl | tee -a preqx.out
ncl makeplots.ncl | tee -a preqx.out
date | tee -a preqx.out


