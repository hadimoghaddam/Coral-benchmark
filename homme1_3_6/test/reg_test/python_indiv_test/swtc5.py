#!/usr/bin/env python


## (1) Import python routines from homme.py and homme_utils.py
import sys,os,commands
sys.path.append(os.path.expanduser("../../python"))
import homme,homme_utils

## (2) Store PWD to run NCL scripts later
pwd = commands.getoutput("echo $PWD")

## (3) build sweqx, output to default_out/reg_test/swtc5/
##    you can either change the default_bld_dir and default_out_dir variables
##    in globalvars.py or you can set $HOMME_BLD and $HOMME_OUT
[bld_dir, out_dir] = homme_utils.get_bld_and_out_dirs("sweqx","reg_test/swtc5")

## (4) Configure and Build HOMME
homme.config(exe="sweqx", # Want shallow water SEM executable
			 bld_dir=bld_dir, # Where to build executable
			 np=4, # 4 x 4 GLL nodes on each element
			 plev=1, # 1 vertical level
			 pio=False, # Interpolate output, don't output on native grid
			 mesh=False) # Do not need to read an Exodus mesh file

## (5) Generate namelist
homme.makenamelist(test_case = "swtc5", # Flow over an isolated mountain
				   accumfreq = 100, # Keep output consistent with swtc5.sh
				   ne = 30, # uniform cube-sphere mesh (10x10x6)
				   ndays = 15, # run for 12 days
				   nu = 1.5e15, # viscosity
				   tstep = 90, # 90s timestep
				   statefreq = 960, # output to screen every 960 timesteps
				   LFTfreq = 1,
				   smooth = 0, # No smoothing
				   io_stride = 1, # Keep output consistent with swtc5.sh
				   filter_mu = 0.005, # Doesn't matter, since filter_freq = 0
				   s_bv = 0.80,       # But makes output consistent w/ swtc5.sh
				   output_varnames1 = ["geop", "zeta", "u", "v"], # output
				   output_frequency = 15, # output on last day only 
				   interp_nlon = 720, # interpolate output onto a
				   interp_nlat = 360, # 720 x 360 grid
				   out_dir = out_dir, # output to directory specified above
				   exe="sweqx") # setup output for shallow water tests

# (6) Run HOMME
homme.execute(exe = "sweqx", # run shallow water SEM executable
			  bld_dir = bld_dir, # location of executable
			  out_dir = out_dir, # output to directory specified above
			  ncpu = 16) # run on this many cores

# (7) Run NCL script
homme_utils.nclexe(exe = pwd+"/../ncl/swtc5ref.ncl",
			 out_dir = out_dir,
			 append = True)
