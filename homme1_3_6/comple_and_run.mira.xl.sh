#!/bin/bash

BUILD_HOMME=1
RUN_JOBS=0

#####################################################################
#  NOW COMPILE HOMME
#####################################################################
if [ $BUILD_HOMME -eq 1 ] ; then
  export HOMME_ROOT=/home/hadi/Downloads/Coral/homme1_3_6
  export PNETCDF_DIR=/soft/libraries/alcf/current/xl/PNETCDF
  export NETCDF_DIR=/usr/local/
  export MAKEJ=16
  export F77=mpif77
  export FC=mpif77
  export CC=mpicc
  export CFLAGS=' -qarch=qp -qtune=qp -O3 -DPNETCDF_VERSION_MAJOR=1 -DPNETCDF_VERSION_MINOR=0 -DHAVE_MPI -DTHREADED_OMP -DFORTRANUNDERSCORE -I$PNETCDF_DIR/include'
  export FCFLAGS='-qarch=qp -qtune=qp -O3 -WF,-DPNETCDF_VERSION_MAJOR=1 -WF,-DPNETCDF_VERSION_MINOR=0 -WF,-DHAVE_MPI -WF,-DTHREADED_OMP -WF,-DFORTRANUNDERSCORE -I$PNETCDF_DIR/include'
  export FFLAGS="$FCFLAGS"
  export F90FLAGS="$FCFLAGS"
  export LDFLAGS="-L$NETCDF_DIR/lib -lnetcdff -lnetcdf -lm -L$PNETCDF_DIR/lib -lpnetcdf  -L../../libs/lapack -L../../libs/blas -L/soft/libraries/unsupported/hdf5-1.8.10/lib -lhdf5_hl -lhdf5 -L/soft/libraries/alcf/current/xl/ZLIB/lib -lz -L../../GPTL -lgptl"
  export LIBS=$LDFLAGS
  export NETCDF_PATH=$NETCDF_DIR
  export PNETCDF_PATH=$PNETCDF_DIR
  export CONFARGS_PIO=" --enable-filesystem-hints=lustre MPIF90=mpixlf2003 MPICC=mpixlc NETCDF_PATH=$NETCDF_DIR"
  export CONFARGS_BLS=""
  export CONFARGS_LPK=""
  export CONFARGS_PRQ=" NP=4 PLEV=26 --with-arch=Linux --with-netcdf=$NETCDF_DIR"
#  cd $HOMME_ROOT/libs/lapack  && ./configure               && make clean                           && make -j $MAKEJ || exit -1
#  cd $HOMME_ROOT/libs/blas    && ./configure               && make clean                           && make -j $MAKEJ || exit -1
#  cd $HOMME_ROOT/utils/pio    && ./configure $CONFARGS_PIO && make clean                           && make -j $MAKEJ || exit -1
#  cd $HOMME_ROOT/utils/timing                              && make clean                           && make -j $MAKEJ || exit -1
  cd $HOMME_ROOT/build/preqx  && ./configure $CONFARGS_PRQ && make clean && make -j $MAKEJ depends && make -j $MAKEJ && mv preqx preqx.cpu|| exit -1
fi

#####################################################################
#  NOW RUN THE JOBS
#####################################################################
if [ $RUN_JOBS -eq 1 ] ; then
  cd $HOMME_ROOT/test/ASP/baroclinic/
  qsub -A Coral_rfp_prep -t 120 -n 1024 --mode script run.job.1024
  qsub -A Coral_rfp_prep -t 120 -n 2048 --mode script run.job.2048
  qsub -A Coral_rfp_prep -t 120 -n 4096 --mode script run.job.4096
fi

