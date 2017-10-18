&ctl_nl
NThreads      = 1
partmethod    = 4
topology      = "cube"
test_case     = "jw_baroclinic"
ne= 0
fine_ne       = -1
qsize         = 0
ndays         = 30
statefreq     = 960
accumfreq     = -1
accumstart    = 200
accumstop     = 1200
restartfreq   = 43200
restartfile   = "./R0001"
runtype       = 0
tstep         = 90
energy_fixer  = 0
integration   = "explicit"
smooth        = 0.005               ! default = 0.005
nu= 1.024e15
nu_s          = -1
nu_p          = 0
hypervis_order = 2
hypervis_subcycle = 1
u_perturb      = 1
hypervis_power = 0 
!max_hypervis_courant = 1.9
mesh_file = 'none'
/
&solver_nl
precon_method = "identity"
maxits        = 500
tol           = 1.e-9
/
&filter_nl
filter_type   = "taylor"
transfer_type = "bv"
filter_freq   = 0
filter_mu     = 0.04D0
p_bv          = 12.0D0
s_bv          = .666666666666666666D0
wght_fm       = 0.10D0
kcut_fm       = 2
/
&vert_nl
vform         = "ccm"
vfile_mid     = "vcoord/camm-26.fbin.littleendian"
vfile_int     = "vcoord/cami-26.fbin.littleendian"
/
&analysis_nl
 interp_gridtype=2
 interp_type=0
 output_start_time= 0
 output_end_time  = -1
 output_timeunits = 1
 output_frequency = 1
 output_varnames1='ps','zeta','T','DIFFT','hypervis','min_dx','max_dx','div','u','v'
 output_type='netcdf'
 io_stride=8
 interp_nlat=128
 interp_nlon=256
/
