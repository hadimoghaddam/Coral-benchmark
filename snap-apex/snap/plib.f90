!-----------------------------------------------------------------------
!
! MODULE: plib_module
!> @brief
!> This module contains the variables that control parallel
!> decomposition and the subroutines for parallel environment setup.
!> Only module that requires 1 library interaction except for
!> time_module (MPI_WTIME).
!
!-----------------------------------------------------------------------
MODULE plib_module
  USE global_module, ONLY: i_knd, r_knd, l_knd
  USE time_module, ONLY: wtime
  USE mpi
  IMPLICIT NONE
  PUBLIC
  INTERFACE glmax
    MODULE PROCEDURE glmax_i, glmax_d, glmax_d_1d
  END INTERFACE glmax
  INTERFACE glmin
    MODULE PROCEDURE glmin_i, glmin_d
  END INTERFACE glmin
  INTERFACE glsum
    MODULE PROCEDURE glsum_d
  END INTERFACE glsum
  INTERFACE rtsum
    MODULE PROCEDURE rtsum_d_1d
  END INTERFACE rtsum
  INTERFACE bcast
    MODULE PROCEDURE bcast_i_scalar, bcast_i_1d, bcast_d_scalar, &
      bcast_d_1d
  END INTERFACE bcast
  INTERFACE psend
    MODULE PROCEDURE psend_d_2d, psend_d_3d
  END INTERFACE psend
  INTERFACE isend
    MODULE PROCEDURE isend_d_3d
  END INTERFACE isend
  INTERFACE precv
    MODULE PROCEDURE precv_d_2d, precv_d_3d
  END INTERFACE precv
  SAVE
!_______________________________________________________________________
!
! Module Input Variables
!
! npey - Number of 1 processes in the y-direction
! npez - Number of 1 processes in the z-direction
! ichunk - Size of work chunks in the x-direction
! nthreads - Number of OpenMP threads for energy parallelism
! nnested - number of nested threads
!_______________________________________________________________________
  INTEGER(i_knd) :: npey=1, npez=1, ichunk=4, nthreads=1, nnested=1
!_______________________________________________________________________
!
! Run-time variables
!
! Note: all ranks are zero based
!
! root - root process for comm_snap, 0
!
! nproc - Number of 1 processes
! iproc - Rank of calling process in base communicator
!
! comm_snap - base communicator, duplicated from MPI_COMM_WORLD
! comm_space - SDD communicator, ndimen-1 grid for 2-D (x-y) or
! 3-D (x-y-z) problems. Non-existent for 1-D (x) problems.
! sproc - Rank of calling process in comm_space
!
! ycomm - y-dimension process communicator
! zcomm - z-dimension process communicator
! yproc - PE column in SDD 2-D PE mesh (comm_space)
! zproc - PE row in SDD 2-D PE mesh (comm_space)
! firsty - logical determining if lowest yproc
! lasty - logical determining if highest yproc
! firstz - logical determining if lowest zproc
! lastz - logical determining if highest zproc
! ylop - rank of preceding yproc in ycomm
! yhip - rank of succeeding yproc in ycomm
! zlop - rank of preceding zproc in zcomm
! zhip - rank of succeeding zproc in zcomm
!
! thread_level - level of 1 thread support
! thread_single - MPI_THREAD_SINGLE
! thread_funneled - MPI_THREAD_FUNNELED
! thread_serialized - MPI_THREAD_SERIALIZED
! thread_multiple - MPI_THREAD_MULTIPLE
! lock(nthreads) - OpenMP lock for each thread
!
! do_nested - true/false use nested threading
!
! use_lock - true/false apply lock to threads 1 communications
! during sweep
!
! pce - Parallel computational efficiency of the run
!_______________________________________________________________________
  INTEGER(i_knd), PARAMETER :: root=0
  INTEGER(i_knd) :: nproc, iproc, comm_snap, comm_space, sproc, ycomm, &
    zcomm, yproc, zproc, ylop, yhip, zlop, zhip, thread_level, &
    thread_single, thread_funneled, thread_serialized, thread_multiple,&
    max_threads
  LOGICAL(l_knd) :: firsty, lasty, firstz, lastz, do_nested, &
    use_lock=.FALSE.
  REAL(r_knd) :: pce
  CONTAINS
  SUBROUTINE pinit ( t1 )
!-----------------------------------------------------------------------
!
! Initialize the 1 process environment. Replicate MPI_COMM_WORLD to
! local communicator. Get each process its rank and total size.
!
!-----------------------------------------------------------------------
    REAL(r_knd), INTENT(OUT) :: t1
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
!_______________________________________________________________________
!
! Set thread support levels
!_______________________________________________________________________
    thread_single = MPI_THREAD_SINGLE
    thread_funneled = MPI_THREAD_FUNNELED
    thread_serialized = MPI_THREAD_SERIALIZED
    thread_multiple = MPI_THREAD_MULTIPLE
!_______________________________________________________________________
!
! Initialize 1 and return available thread support level. Prefer
! thread_multiple but require thread_serialized. Abort for insufficient
! thread support. Do not want to use MPI_COMM_WORLD everywhere, so
! duplicate to comm_snap. Start the timer.
!_______________________________________________________________________
    CALL MPI_INIT_THREAD ( thread_serialized, thread_level, ierr )
    CALL wtime ( t1 )
    CALL MPI_COMM_DUP ( MPI_COMM_WORLD, comm_snap, ierr )
!_______________________________________________________________________
!
! Get the communicator size and each process rank within the main
! communicator
!_______________________________________________________________________
    CALL MPI_COMM_SIZE ( comm_snap, nproc, ierr )
    CALL MPI_COMM_RANK ( comm_snap, iproc, ierr )
!_______________________________________________________________________
!
! Put a barrier for every process to reach this point.
!_______________________________________________________________________
    CALL barrier ( comm_snap )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE pinit
  SUBROUTINE barrier ( comm )
!-----------------------------------------------------------------------
!
! 1 barrier
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: comm
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
!_______________________________________________________________________
    CALL MPI_BARRIER ( comm, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE barrier
  SUBROUTINE pcomm_set
!-----------------------------------------------------------------------
!
! Setup the SDD communicator.
!
!-----------------------------------------------------------------------
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
    INTEGER(i_knd), DIMENSION(2) :: dims
    LOGICAL(l_knd) :: reorder
    LOGICAL(l_knd), DIMENSION(2) :: periodic, remain
!_______________________________________________________________________
!
! Use 1 routines to create a Cartesian topology
!_______________________________________________________________________
    dims(1) = npez
    dims(2) = npey
    periodic = .FALSE.
    reorder = .TRUE.
    CALL MPI_CART_CREATE ( comm_snap, 2, dims, periodic, reorder, &
      comm_space, ierr )
!_______________________________________________________________________
!
! Set up the sub-communicators of the cartesian grid
!_______________________________________________________________________
    remain(1) = .FALSE.
    remain(2) = .TRUE.
    CALL MPI_CART_SUB ( comm_space, remain, ycomm, ierr )
    remain(1) = .TRUE.
    remain(2) = .FALSE.
    CALL MPI_CART_SUB ( comm_space, remain, zcomm, ierr )
!_______________________________________________________________________
!
! Get comm_space, ycomm, and zcomm ranks
!_______________________________________________________________________
    CALL MPI_COMM_RANK ( comm_space, sproc, ierr )
    CALL MPI_COMM_RANK ( ycomm, yproc, ierr )
    CALL MPI_COMM_RANK ( zcomm, zproc, ierr )
!_______________________________________________________________________
!
! Set some variables used during solution
!_______________________________________________________________________
    IF ( yproc == 0 ) THEN
      firsty = .TRUE.
      ylop = yproc
    ELSE
      firsty = .FALSE.
      ylop = yproc - 1
    END IF
    IF ( yproc == npey-1 ) THEN
      lasty = .TRUE.
      yhip = yproc
    ELSE
      lasty = .FALSE.
      yhip = yproc + 1
    END IF
    IF ( zproc == 0 ) THEN
      firstz = .TRUE.
      zlop = zproc
    ELSE
      firstz = .FALSE.
      zlop = zproc - 1
    END IF
    IF ( zproc == npez-1 ) THEN
      lastz = .TRUE.
      zhip = zproc
    ELSE
      lastz = .FALSE.
      zhip = zproc + 1
    END IF
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE pcomm_set
  SUBROUTINE pend
!-----------------------------------------------------------------------
!
! Call to end 1 processes
!
!-----------------------------------------------------------------------
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
!_______________________________________________________________________
    CALL MPI_FINALIZE ( ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE pend
  SUBROUTINE glmax_i ( value, comm )
!-----------------------------------------------------------------------
!
! All reduce global max value (integer). Use specified communicator.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: comm
    INTEGER(i_knd), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr, x
!_______________________________________________________________________
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_ALLREDUCE ( value, x, 1, MPI_INTEGER, MPI_MAX, comm, ierr )
    value = x
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE glmax_i
  SUBROUTINE glmax_d ( value, comm )
!-----------------------------------------------------------------------
!
! All reduce global max value (double precision float). Use specified
! communicator.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: comm
    REAL(r_knd), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
    REAL(r_knd) :: x
!_______________________________________________________________________
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_ALLREDUCE ( value, x, 1, MPI_DOUBLE_PRECISION, MPI_MAX, &
      comm, ierr )
    value = x
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE glmax_d
  SUBROUTINE glmax_d_1d ( value, dlen, comm )
!-----------------------------------------------------------------------
!
! All reduce global max value (double precision float) for 1-d array.
! Use specified communicator.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: dlen, comm
    REAL(r_knd), DIMENSION(dlen), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
    REAL(r_knd), DIMENSION(dlen) :: x
!_______________________________________________________________________
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_ALLREDUCE ( value, x, dlen, MPI_DOUBLE_PRECISION, MPI_MAX,&
      comm, ierr )
    value = x
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE glmax_d_1d
  SUBROUTINE glmin_i ( value, comm )
!-----------------------------------------------------------------------
!
! All reduce global min value (integer). Use specified communicator.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: comm
    INTEGER(i_knd), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr, x
!_______________________________________________________________________
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_ALLREDUCE ( value, x, 1, MPI_INTEGER, MPI_MIN, comm, ierr )
    value = x
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE glmin_i
  SUBROUTINE glmin_d ( value, comm )
!-----------------------------------------------------------------------
!
! All reduce global min value (double precision float). Use specified
! communicator.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: comm
    REAL(r_knd), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
    REAL(r_knd) :: x
!_______________________________________________________________________
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_ALLREDUCE ( value, x, 1, MPI_DOUBLE_PRECISION, MPI_MIN, &
      comm, ierr )
    value = x
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE glmin_d
  SUBROUTINE glsum_d ( value, comm )
!-----------------------------------------------------------------------
!
! All reduce global sum value (double precision float). Use specified
! communicator.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: comm
    REAL(r_knd), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
    REAL(r_knd) :: x
!_______________________________________________________________________
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_ALLREDUCE ( value, x, 1, MPI_DOUBLE_PRECISION, MPI_SUM, &
      comm, ierr )
    value = x
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE glsum_d
  SUBROUTINE rtsum_d_1d ( value, dlen, comm, rtproc )
!-----------------------------------------------------------------------
!
! Normal reduce-to-root sum (double precision float) for 1-d array. Use
! specified communicator.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: dlen, comm, rtproc
    REAL(r_knd), DIMENSION(dlen), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
    REAL(r_knd), DIMENSION(dlen) :: x
!_______________________________________________________________________
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_REDUCE ( value, x, dlen, MPI_DOUBLE_PRECISION, MPI_SUM, &
      rtproc, comm, ierr )
    value = x
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE rtsum_d_1d
  SUBROUTINE bcast_i_scalar ( value, comm, bproc )
!-----------------------------------------------------------------------
!
! Broadcast (integer scalar). Use specified communicator and casting
! proc.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: comm, bproc
    INTEGER(i_knd), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
!_______________________________________________________________________
    IF ( nproc == 1 ) RETURN
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_BCAST ( value, 1, MPI_INTEGER, bproc, comm, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE bcast_i_scalar
  SUBROUTINE bcast_i_1d ( value, ilen, comm, bproc )
!-----------------------------------------------------------------------
!
! Broadcast (integer 1d array). Use specified communicator and casting
! proc.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: ilen, comm, bproc
    INTEGER(i_knd), DIMENSION(ilen), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
!_______________________________________________________________________
    IF ( nproc == 1 ) RETURN
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_BCAST ( value, ilen, MPI_INTEGER, bproc, comm, &
      ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE bcast_i_1d
  SUBROUTINE bcast_d_scalar ( value, comm, bproc )
!-----------------------------------------------------------------------
!
! Broadcast (double precision float scalar). Use specified communicator
! and casting proc.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: comm, bproc
    REAL(r_knd), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
!_______________________________________________________________________
    IF ( nproc == 1 ) RETURN
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_BCAST ( value, 1, MPI_DOUBLE_PRECISION, bproc, comm, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE bcast_d_scalar
  SUBROUTINE bcast_d_1d ( value, dlen, comm, bproc )
!-----------------------------------------------------------------------
!
! Broadcast (double precision float 1d array). Use specified
! communicator and casting proc.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: dlen, comm, bproc
    REAL(r_knd), DIMENSION(dlen), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
!_______________________________________________________________________
    IF ( nproc == 1 ) RETURN
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_BCAST ( value, dlen, MPI_DOUBLE_PRECISION, bproc, comm, &
      ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE bcast_d_1d
  SUBROUTINE psend_d_2d ( proc, myproc, d1, d2, value, comm, mtag )
!-----------------------------------------------------------------------
!
! Send a rank-3 double precision array.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: proc, myproc, d1, d2, comm, mtag
    REAL(r_knd), DIMENSION(d1,d2), INTENT(IN) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: dlen, ierr
!_______________________________________________________________________
    IF ( proc==myproc .OR. comm==MPI_COMM_NULL ) RETURN
    dlen = d1*d2
    CALL MPI_SEND ( value, dlen, MPI_DOUBLE_PRECISION, proc, mtag, &
      comm, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE psend_d_2d
  SUBROUTINE psend_d_3d ( proc, myproc, d1, d2, d3, value, comm, mtag )
!-----------------------------------------------------------------------
!
! Send a rank-3 double precision array.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: proc, myproc, d1, d2, d3, comm, mtag
    REAL(r_knd), DIMENSION(d1,d2,d3), INTENT(IN) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: dlen, ierr
!_______________________________________________________________________
    IF ( proc==myproc .OR. comm==MPI_COMM_NULL ) RETURN
    dlen = d1*d2*d3
    CALL MPI_SEND ( value, dlen, MPI_DOUBLE_PRECISION, proc, mtag, &
      comm, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE psend_d_3d
  SUBROUTINE isend_d_3d ( proc, myproc, d1, d2, d3, value, comm, mtag, &
    req )
!-----------------------------------------------------------------------
!
! Non-blocking-send a rank-3 double precision array.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: proc, myproc, d1, d2, d3, comm, mtag
    INTEGER(i_knd), INTENT(INOUT) :: req
    REAL(r_knd), DIMENSION(d1,d2,d3), INTENT(IN) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: dlen, ierr
!_______________________________________________________________________
    IF ( proc==myproc .OR. comm==MPI_COMM_NULL ) RETURN
    dlen = d1*d2*d3
    CALL MPI_ISEND ( value, dlen, MPI_DOUBLE_PRECISION, proc, mtag, &
      comm, req, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE isend_d_3d
  SUBROUTINE precv_d_2d ( proc, myproc, d1, d2, value, comm, mtag )
!-----------------------------------------------------------------------
!
! Send a rank-3 double precision array.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: proc, myproc, d1, d2, comm, mtag
    REAL(r_knd), DIMENSION(d1,d2), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: dlen, ierr, istat(MPI_STATUS_SIZE)
!_______________________________________________________________________
    IF ( proc==myproc .OR. comm==MPI_COMM_NULL ) RETURN
    dlen = d1*d2
    CALL MPI_RECV ( value, dlen, MPI_DOUBLE_PRECISION, proc, mtag, &
      comm, istat, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE precv_d_2d
  SUBROUTINE precv_d_3d ( proc, myproc, d1, d2, d3, value, comm, mtag )
!-----------------------------------------------------------------------
!
! Send a rank-3 double precision array.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: proc, myproc, d1, d2, d3, comm, mtag
    REAL(r_knd), DIMENSION(d1,d2,d3), INTENT(INOUT) :: value
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: dlen, ierr, istat(MPI_STATUS_SIZE)
!_______________________________________________________________________
    IF ( proc==myproc .OR. comm==MPI_COMM_NULL ) RETURN
    dlen = d1*d2*d3
    CALL MPI_RECV ( value, dlen, MPI_DOUBLE_PRECISION, proc, mtag, &
      comm, istat, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE precv_d_3d
  SUBROUTINE cartrank ( coord, rank, comm )
!-----------------------------------------------------------------------
!
! Return the rank of a proc defined by the coordinates of the Cartesian
! communicator.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(OUT) :: rank
    INTEGER(i_knd), INTENT(IN) :: comm
    INTEGER(i_knd), DIMENSION(2), INTENT(IN) :: coord
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: ierr
!_______________________________________________________________________
    IF ( comm == MPI_COMM_NULL ) RETURN
    CALL MPI_CART_RANK ( comm, coord, rank, ierr )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE cartrank
  SUBROUTINE waitinit ( req, d1 )
!-----------------------------------------------------------------------
!
! Initialize asynchronous communication request array to null state.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: d1
    INTEGER(i_knd), DIMENSION(d1), INTENT(OUT) :: req
!_______________________________________________________________________
    req = MPI_REQUEST_NULL
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE waitinit
  SUBROUTINE waitall ( req, d1 )
!-----------------------------------------------------------------------
!
! Wait for all asynchronous communications encapsulated in the req array
! to finish.
!
!-----------------------------------------------------------------------
    INTEGER(i_knd), INTENT(IN) :: d1
    INTEGER(i_knd), DIMENSION(d1), INTENT(INOUT) :: req
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: info
    INTEGER(i_knd), DIMENSION(MPI_STATUS_SIZE,d1) :: stat
!_______________________________________________________________________
    CALL MPI_WAITALL ( d1, req, stat, info )
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE waitall
  SUBROUTINE pinit_omp ( ierr, error )
!-----------------------------------------------------------------------
!
! Setup the number of OpenMP threads. Check if any proc is exceeding
! max threads. Reset and report if so.
!
!-----------------------------------------------------------------------
    CHARACTER(LEN=64), INTENT(OUT) :: error
    INTEGER(i_knd), INTENT(OUT) :: ierr
!_______________________________________________________________________
!
! Local variables
!_______________________________________________________________________
    INTEGER(i_knd) :: max_threads
!_______________________________________________________________________
    ierr = 0
    error = ' '
    max_threads = 1
    nthreads = 1
    do_nested = .FALSE.
!_______________________________________________________________________
!_______________________________________________________________________
  END SUBROUTINE pinit_omp
  SUBROUTINE plock_omp ( dowhat, nlock )
    CHARACTER(LEN=*), INTENT(IN) :: dowhat
    INTEGER(i_knd), INTENT(IN) :: nlock
  END SUBROUTINE plock_omp
  FUNCTION thread_num ()
    INTEGER(i_knd) :: thread_num
    thread_num = 0
  END FUNCTION thread_num
END MODULE plib_module
