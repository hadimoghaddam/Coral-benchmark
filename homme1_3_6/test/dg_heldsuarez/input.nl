!=======================================================!
! 	1 day = 1 * 24 * 3600 = 86400 sec		!
! 	nmax  = ndays * 86400 / tstep 			!
! 	6 days at 10.0 stepsize: nmax= 51840 		!
!		  15.0 stepsize: nmax= 34560		!
!                 30.0 stepsize: nmax= 17280 		!
!=======================================================!
!	1 hour= 1 * 3600 = 3600 sec			!
!	2 hrs at 10.0 stepsize:  remapfreq= 720  	!
!	2 hrs at 15.0 stepsize:  remapfreq= 480  	!
!	2 hrs at 30.0 stepsize:  remapfreq= 240  	!
!=======================================================!
&ctl_nl
NThreads      = 1
partmethod    = 4
topology      = "cube"
test_case     = "heldsuarez"
!test_case    = "jw_bcl"
ne            =      6
ndays         =   1200
nmax          =5184000
remapfreq     =    180
statefreq     =   4320
accumfreq     =   4320
accumstart    =    200
accumstop     =    500
tasknum       = 0
restartfreq   =-1
restartfile   = "./restart/"
runtype       = 0
tstep         = 20.D0
integration   = "explicit"
smooth        = 0.05
nu            = 7.0e5
/
&solver_nl
precon_method = "block_jacobi"
maxits        = 100
tol           = 1.e-12
/
&filter_nl
transfer_type = "bv"
filter_type   = "taylor"
filter_freq   = 1
filter_mu     = 0.05D0
p_bv          = 12.0D0
s_bv          = 0.666666666666666666D0
wght_fm       = 0.10D0
kcut_fm       = 2
/
&analysis_nl
!=======================================================!
!  currently up to 5 streams are allowed		!
!  output_stream_count=1				!
!							!
!  timunits: 0= steps, 1=days, 2=hours			!
!  output_timeunits=1,2 				!
!  output_start_time=0,1176				!			
!  output_end_time=-1,-1				!
!  output_frequency=1,1 				!
!  output_dir ="./movies/"				!
!							!
!  allowed variables: 'ps   ','geop ','u    ','v    ',	!
!                     'latp ','lonp ','latv ','lonv ',	!
!                     'elem ','Time ','T    ','p3d  ', 	!
!		      'dgs  '				!
!  'dgs' includes 'ps','T850','zeta850' 		!
!							!
!  output_varnames1-5					!
!=======================================================!
output_start_time= 0
output_end_time  =-1
output_frequency = 50
output_timeunits = 1
output_varnames1 ='u','T'
!output_varnames1 ='ps','dgs','p','T','zeta'
/
&dg_nl
/
