#!/usr/bin/env python

import sys,os,commands
sys.path.append(os.path.expanduser("../python"))
import homme,homme_utils,globalvars

# User sets test_case (swtc1, swtc2, swtc5:
test_case = "swtc2"

# Set ndays based on test being run
[refine,ndays,plev] = homme_utils.set_tc_specific(test_case)

# Always use NP=4...
np = 4

# Set pio to true if you want to output on native grid rather than interpolate
# Otherwise choose size of interpolated grid
pio = False
interp_nlon = 720
interp_nlat = 360

# Set ne in coarse region, amount of refinement, and amount of smoothing
ne = 15
ref = 2
smth = 0

# Set number of cores to run on
ncpu = 8


# nu and timestep are calculated automatically
# but you can easily overwrite them here
# (also set hypervis_subcycle here)
hypervis_power = 3.322 
[nu, tstep] = homme_utils.get_nu_tstep(ne=ne,
									   ref=ref,
									   hypervis_power=hypervis_power,
									   test_case=test_case)

hypervis_subcycle = 1
# Setting this value will adjust nu in elements that exceed Courant limit 
#max_hypervis_courant = "1d99"
max_hypervis_courant = 1.9

### USER SHOULDN'T NEED TO CHANGE ANYTHING BELOW HERE

# Default State Frequency is to output every 12 hours
statefreq = int(12.0*3600.0/tstep)

# Select mesh based on refinement type, ne, ref, and smooth
mesh = homme_utils.get_mesh(refine,ne,ref,smth)
mesh_file = homme_utils.find_mesh(mesh)

# Specify build directory and output directory
# Note that sub_dir is a sub-directory of the top-level out_dir
sub_dir = "/mesh-refine/" + test_case + "/" + mesh + "/dt" + str(tstep)
if nu is not 0:
	if hypervis_subcycle is not 1:
		sub_dir = sub_dir + "-sub" + str(hypervis_subcycle)
	sub_dir = sub_dir + "-nu" + str(nu)
	if hypervis_power is not 0:
		sub_dir = sub_dir + "-hvp" + str(hypervis_power)
	if max_hypervis_courant is not "1d99":
		sub_dir = sub_dir + "-maxC" + str(max_hypervis_courant)
[bld_dir, out_dir] = homme_utils.get_bld_and_out_dirs("sweqx",sub_dir)

# Configure HOMME
homme.config(exe="sweqx",np=np,plev=plev,pio=pio,mesh=True,bld_dir=bld_dir)
# Build namelist
homme.makenamelist(test_case = test_case,
				   nu = nu,
				   hypervis_power = hypervis_power,
				   hypervis_subcycle = hypervis_subcycle,
				   ne = 0,
				   fine_ne = ne*ref,
				   ndays = ndays,
				   tstep = tstep,
				   statefreq = statefreq,
				   LFTfreq = 1,
				   smooth = 0,
				   interp_nlon = interp_nlon,
				   interp_nlat = interp_nlat,
				   out_dir = out_dir,
				   mesh_file = mesh_file,
				   max_hypervis_courant = max_hypervis_courant,
				   exe="sweqx")

# Run HOMME
homme.execute(exe="sweqx",
			  bld_dir = bld_dir,
			  out_dir = out_dir,
			  ncpu = ncpu)
