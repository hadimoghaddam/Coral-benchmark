GFORTRAN module version '10' created from ../../src/share/cslam_line_integrals_mod.F90
MD5:fa4ebc7b68b9337bb24f44382c85222e -- If you edit this, you'll get what you deserve.

(() () () () () () () () () () () () () () () () () () () () () () ()
() () () ())

()

()

(('mpifcmb5' 2 1 0 '') ('mpifcmb9' 3 1 0 '') ('mpipriv1' 4 1 0 '') (
'mpipriv2' 5 1 0 '') ('mpiprivc' 6 1 0 ''))

()

()

(7 'bignum' 'cslam_line_integrals_mod' '' 1 ((PARAMETER UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN IMPLICIT-SAVE 0 0) (REAL 8 0 0 0 REAL ()) 0 0 () (
CONSTANT (REAL 8 0 0 0 REAL ()) 0 '0.56bc75e2d63100@17') () 0 () () () 0
0)
8 'compute_weights' 'cslam_line_integrals_mod' '' 1 ((PROCEDURE
UNKNOWN-INTENT MODULE-PROC DECL UNKNOWN 0 0 SUBROUTINE) (UNKNOWN 0 0 0 0
UNKNOWN ()) 9 0 (10 11 12 13 14 15) () 0 () () () 0 0)
16 'tiny' 'cslam_line_integrals_mod' '' 1 ((PARAMETER UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN IMPLICIT-SAVE 0 0) (REAL 8 0 0 0 REAL ()) 0 0 () (
CONSTANT (REAL 8 0 0 0 REAL ()) 0 '0.119799812dea11@-9') () 0 () () () 0
0)
2 'mpi_unweighted' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 IN_COMMON) (INTEGER 4 0 0 0 INTEGER ())
0 0 () () 0 () () () 0 0)
3 'mpi_weights_empty' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 IN_COMMON) (INTEGER 4 0 0 0 INTEGER ())
0 0 () () 0 () () () 0 0)
4 'mpi_bottom' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 IN_COMMON) (INTEGER 4 0 0 0 INTEGER ())
0 17 () () 0 () () () 0 0)
5 'mpi_statuses_ignore' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION IN_COMMON) (INTEGER 4 0 0 0
INTEGER ()) 0 18 () (2 0 EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '5') (CONSTANT (INTEGER
4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1'))
0 () () () 0 0)
6 'mpi_argvs_null' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION IN_COMMON) (CHARACTER 1 0 0 0
CHARACTER ((CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1'))) 0 19 () (2 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1')) 0 () () () 0 0)
10 'cslam' '' '' 9 ((VARIABLE INOUT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0
DUMMY) (DERIVED 20 0 0 0 DERIVED ()) 0 0 () () 0 () () () 0 0)
11 'nreconstruction' '' '' 9 ((VARIABLE IN UNKNOWN-PROC UNKNOWN UNKNOWN
0 0 DUMMY) (INTEGER 4 0 0 0 INTEGER ()) 0 0 () () 0 () () () 0 0)
12 'weights_all' '' '' 9 ((VARIABLE OUT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0
DIMENSION DUMMY) (REAL 8 0 0 0 REAL ()) 0 0 () (2 0 EXPLICIT (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '360') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (VARIABLE (
INTEGER 4 0 0 0 INTEGER ()) 0 11 ())) 0 () () () 0 0)
13 'weights_eul_index_all' '' '' 9 ((VARIABLE OUT UNKNOWN-PROC UNKNOWN
UNKNOWN 0 0 DIMENSION DUMMY) (INTEGER 4 0 0 0 INTEGER ()) 0 0 () (2 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '360') (CONSTANT (INTEGER 4 0 0 0 INTEGER
()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2')) 0 () () () 0 0)
14 'weights_lgr_index_all' '' '' 9 ((VARIABLE OUT UNKNOWN-PROC UNKNOWN
UNKNOWN 0 0 DIMENSION DUMMY) (INTEGER 4 0 0 0 INTEGER ()) 0 0 () (2 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '360') (CONSTANT (INTEGER 4 0 0 0 INTEGER
()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2')) 0 () () () 0 0)
15 'jall' '' '' 9 ((VARIABLE OUT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DUMMY)
(INTEGER 4 0 0 0 INTEGER ()) 0 0 () () 0 () () () 0 0)
17 'mpi_in_place' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 IN_COMMON) (INTEGER 4 0 0 0 INTEGER ())
0 21 () () 0 () () () 0 0)
18 'mpi_errcodes_ignore' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION IN_COMMON) (INTEGER 4 0 0 0
INTEGER ()) 0 0 () (1 0 EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1')) 0 () () () 0 0)
19 'mpi_argv_null' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION IN_COMMON) (CHARACTER 1 0 0 0
CHARACTER ((CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1'))) 0 0 () (1 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '1')) 0 () () () 0 0)
20 'Cslam_struct' 'cslam_control_volume_mod' '' 9 ((DERIVED
UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 SEQUENCE) (UNKNOWN 0 0 0
0 UNKNOWN ()) 0 0 () () 0 ((22 'c' (REAL 8 0 0 0 REAL ()) (5 0 EXPLICIT
(CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-3') (CONSTANT (INTEGER 4 0 0
0 INTEGER ()) 0 '8') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-3') (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '8') (CONSTANT (INTEGER 4 0 0 0
INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0
INTEGER ()) 0 '5') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '3')) (UNKNOWN-FL UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION) UNKNOWN-ACCESS ()) (23
'asphere' (DERIVED 24 0 0 0 DERIVED ()) (2 0 EXPLICIT (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '5') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER
4 0 0 0 INTEGER ()) 0 '5')) (UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC
UNKNOWN UNKNOWN 0 0 DIMENSION) UNKNOWN-ACCESS ()) (25 'dalpha' (REAL 8 0
0 0 REAL ()) () (UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN
0 0) UNKNOWN-ACCESS ()) (26 'dbeta' (REAL 8 0 0 0 REAL ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (27 'dsphere' (DERIVED 24 0 0 0 DERIVED ()) (2 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '5') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '5')) (UNKNOWN-FL
UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (28 'centersphere' (DERIVED 24 0 0 0 DERIVED ()) (2 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '4') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '4')) (UNKNOWN-FL
UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (29 'area_sphere' (REAL 8 0 0 0 REAL ()) (2 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '0') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '5') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '0') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '5')) (UNKNOWN-FL
UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (30 'spherecentroid' (REAL 8 0 0 0 REAL ()) (3 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '5') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '0') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '5') (CONSTANT (INTEGER
4 0 0 0 INTEGER ()) 0 '0') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '5'))
(UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (31 'faceno' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (32 'nbrsface' (INTEGER 4 0 0 0 INTEGER ()) (1 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '8')) (UNKNOWN-FL UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION) UNKNOWN-ACCESS ()) (33
'cubeboundary' (INTEGER 4 0 0 0 INTEGER ()) () (UNKNOWN-FL
UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0) UNKNOWN-ACCESS ()) (34
'elem_mass' (REAL 8 0 0 0 REAL ()) () (UNKNOWN-FL UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0) UNKNOWN-ACCESS ()) (35 'maxcfl' (REAL
8 0 0 0 REAL ()) (2 0 EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0
'1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2') (CONSTANT (INTEGER 4
0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1'))
(UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (36 'jx_min' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (37 'jx_max' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (38 'jy_min' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (39 'jy_max' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (40 'jx_min1' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (41 'jx_max1' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (42 'jy_min1' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (43 'jy_max1' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (44 'jx_min2' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (45 'jx_max2' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (46 'jy_min2' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (47 'jy_max2' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (48 'acartx' (REAL 8 0 0 0 REAL ()) (1 0 EXPLICIT (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (CONSTANT (INTEGER 4 0 0 0
INTEGER ()) 0 '7')) (UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN
UNKNOWN 0 0 DIMENSION) UNKNOWN-ACCESS ()) (49 'acarty' (REAL 8 0 0 0
REAL ()) (1 0 EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '7')) (UNKNOWN-FL UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION) UNKNOWN-ACCESS ()) (50
'acartx1' (REAL 8 0 0 0 REAL ()) (1 0 EXPLICIT (CONSTANT (INTEGER 4 0 0
0 INTEGER ()) 0 '-1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '7')) (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (51 'acarty1' (REAL 8 0 0 0 REAL ()) (1 0 EXPLICIT (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (CONSTANT (INTEGER 4 0 0 0
INTEGER ()) 0 '7')) (UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN
UNKNOWN 0 0 DIMENSION) UNKNOWN-ACCESS ()) (52 'acartx2' (REAL 8 0 0 0
REAL ()) (1 0 EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '7')) (UNKNOWN-FL UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION) UNKNOWN-ACCESS ()) (53
'acarty2' (REAL 8 0 0 0 REAL ()) (1 0 EXPLICIT (CONSTANT (INTEGER 4 0 0
0 INTEGER ()) 0 '-1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '7')) (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (54 'swap1' (LOGICAL 4 0 0 0 LOGICAL ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (55 'swap2' (LOGICAL 4 0 0 0 LOGICAL ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (56 'invx1' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (57 'invy1' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (58 'invx2' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (59 'invy2' (INTEGER 4 0 0 0 INTEGER ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (60 'interp' (REAL 8 0 0 0 REAL ()) (3 0 EXPLICIT (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (CONSTANT (INTEGER 4 0 0 0
INTEGER ()) 0 '6') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2') (CONSTANT (INTEGER 4 0 0 0
INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2')) (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (61 'interphalo' (REAL 8 0 0 0 REAL ()) (3 0 EXPLICIT
(CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (CONSTANT (INTEGER 4 0 0
0 INTEGER ()) 0 '6') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '1') (
CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2') (CONSTANT (INTEGER 4 0 0 0
INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2')) (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (62 'interphaloex' (REAL 8 0 0 0 REAL ()) (3 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '6') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2') (CONSTANT (INTEGER
4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2'))
(UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (63 'ibase' (INTEGER 4 0 0 0 INTEGER ()) (3 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '6') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2') (CONSTANT (INTEGER
4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2'))
(UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (64 'ibasehalo' (INTEGER 4 0 0 0 INTEGER ()) (3 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '6') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2') (CONSTANT (INTEGER
4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2'))
(UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ()) (65 'ibasehaloex' (INTEGER 4 0 0 0 INTEGER ()) (3 0
EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '-1') (CONSTANT (
INTEGER 4 0 0 0 INTEGER ()) 0 '6') (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2') (CONSTANT (INTEGER
4 0 0 0 INTEGER ()) 0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '2'))
(UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION)
UNKNOWN-ACCESS ())) PUBLIC (() () () ()) () 0 0 16465301)
21 'mpi_status_ignore' 'parallel_mod' '' 1 ((VARIABLE UNKNOWN-INTENT
UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 DIMENSION IN_COMMON) (INTEGER 4 0 0 0
INTEGER ()) 0 0 () (1 0 EXPLICIT (CONSTANT (INTEGER 4 0 0 0 INTEGER ())
0 '1') (CONSTANT (INTEGER 4 0 0 0 INTEGER ()) 0 '5')) 0 () () () 0 0)
24 'Spherical_polar_t' 'coordinate_systems_mod' '' 9 ((DERIVED
UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0 SEQUENCE) (UNKNOWN 0 0 0
0 UNKNOWN ()) 0 0 () () 0 ((66 'r' (REAL 8 0 0 0 REAL ()) () (
UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0)
UNKNOWN-ACCESS ()) (67 'lon' (REAL 8 0 0 0 REAL ()) () (UNKNOWN-FL
UNKNOWN-INTENT UNKNOWN-PROC UNKNOWN UNKNOWN 0 0) UNKNOWN-ACCESS ()) (68
'lat' (REAL 8 0 0 0 REAL ()) () (UNKNOWN-FL UNKNOWN-INTENT UNKNOWN-PROC
UNKNOWN UNKNOWN 0 0) UNKNOWN-ACCESS ())) PUBLIC (() () () ()) () 0 0
42606962)
)

('bignum' 0 7 'compute_weights' 0 8 'tiny' 0 16)
