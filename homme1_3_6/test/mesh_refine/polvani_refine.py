#!/usr/bin/env python

import sys,os,commands
sys.path.append(os.path.expanduser("../python"))
import homme,homme_utils,globalvars

# User sets test_case (swtc1, swtc2, swtc5:
test_case = "baroclinic"

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
ncpu = 16

# nu and timestep are calculated automatically
# but you can easily overwrite them here
# (also set hypervis_subcycle here)
[nu, tstep] = homme_utils.get_nu_tstep(ne=ne,ref=ref,test_case=test_case)

### USER SHOULDN'T NEED TO CHANGE ANYTHING BELOW HERE

# Default State Frequency is to output every 12 hours
statefreq = int(12.0*3600.0/tstep)

# Select mesh based on refinement type, ne, ref, and smooth
mesh = homme_utils.get_mesh(refine,ne,ref,smth)
mesh_file = homme_utils.find_mesh(mesh)

# Specify build directory and output directory
# Note that sub_dir is a sub-directory of the top-level out_dir
sub_dir = "/mesh-refine/" + test_case + "/" + mesh + "/dt" + str(tstep)
[bld_dir, out_dir] = homme_utils.get_bld_and_out_dirs("preqx",sub_dir)

homme.config(exe="preqx",np=np,plev=plev,pio=pio,mesh=True,bld_dir=bld_dir)
homme.makenamelist(test_case = test_case,
				   plev = plev,
				   nu = nu,
				   nu_s = nu,
				   smooth = 0.05,
				   hypervis_order = 1,
				   ne = 0,
				   fine_ne = ne*ref,
				   ndays = ndays,
				   tstep = tstep,
				   statefreq = statefreq,
				   output_varnames1 = ["ps","zeta","T"],
				   interp_nlon = interp_nlon,
				   interp_nlat = interp_nlat,
				   mesh_file = mesh_file,
				   out_dir = out_dir,
				   exe="preqx")
homme.execute(exe = "preqx",
			  bld_dir = bld_dir,
			  out_dir = out_dir,
			  ncpu = ncpu)
