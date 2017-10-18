#!/bin/bash

#THIS MUST BE SET TO THE PROPER DIRECTORY BEFORE RUNNING THE SCRIPT
export HOMME_ROOT=/tmp/work/$USER/homme1_3_6


source /opt/modules/default/init/bash
module rm PrgEnv-cray
module rm PrgEnv-intel
module rm PrgEnv-gnu
module rm PrgEnv-pathscale
module add PrgEnv-pgi
module add netcdf parallel-netcdf


export MAKEJ=16
export FC=ftn
export CC=cc
export CFLAGS='-fast -Minform=inform -Mneginfo -mp -DPNETCDF_VERSION_MAJOR=1 -DPNETCDF_VERSION_MINOR=0 -DHAVE_MPI -DTHREADED_OMP -DFORTRANUNDERSCORE'
export FCFLAGS=$CFLAGS
export FFLAGS=$CFLAGS
export F90FLAGS=$CFLAGS
export LDFLAGS="-L$PNETCDF_DIR/lib -lpnetcdf"
export LIBS=$LDFLAGS
export NETCDF_PATH=$NETCDF_DIR
export PNETCDF_PATH=$PNETCDF_DIR
export CONFARGS_PIO="--host=bulldozer-64 --enable-filesystem-hints=lustre MPIF90=ftn MPICC=cc"
export CONFARGS_BLS="--host=bulldozer-64"
export CONFARGS_LPK="--host=bulldozer-64"
export CONFARGS_PRQ="--host=bulldozer-64 NP=4 PLEV=26 --with-arch=Linux --with-netcdf=$NETCDF_DIR"


cd $HOMME_ROOT/utils/pio    && ./configure $CONFARGS_PIO && make clean                           && make -j $MAKEJ || exit -1
cd $HOMME_ROOT/utils/timing                              && make clean                           && make -j $MAKEJ || exit -1
cd $HOMME_ROOT/build/preqx  && ./configure $CONFARGS_PRQ && make clean && make -j $MAKEJ depends && make -j $MAKEJ && mv preqx preqx.cpu|| exit -1


cd $HOMME_ROOT/test/ASP/baroclinic/
qsub run.job.256
qsub run.job.512
qsub run.job.1024
qsub run.job.2048
qsub run.job.4096
qsub run.job.6144
qsub run.job.8192
qsub run.job.12288

