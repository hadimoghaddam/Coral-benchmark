#!/usr/bin/env python

## (1) Import python routines from homme.py and homme_utils.py
import sys,os
sys.path.append(os.path.expanduser("../../python"))
import homme,homme_utils

## (2) build sweqx, output to default_out/reg_test/swtc1/
##    you can either change the default_bld_dir and default_out_dir variables
##    in globalvars.py or you can set $HOMME_BLD and $HOMME_OUT
[bld_dir, out_dir] = homme_utils.get_bld_and_out_dirs("sweqx","reg_test/swtc1")

## (3) Configure and Build HOMME
homme.config(exe="sweqx", # Want shallow water SEM executable
			 bld_dir=bld_dir, # Where to build executable
			 np=8, # 8 x 8 GLL nodes on each element
			 plev=4, # 4 vertical levels
			 pio=False, # Interpolate output, don't output on native grid
			 mesh=False) # Do not need to read an Exodus mesh file

## (4) Generate namelist
homme.makenamelist(test_case = "swtc1", # solid-body rotation
				   accumfreq = 100, # Keep output consistent with swtc1.sh
				   ne = 10, # uniform cube-sphere mesh (10x10x6)
				   ndays = 12, # run for 12 days
				   nu = 0, # no viscosity
				   tstep = 480, # 480s timestep
				   statefreq = 180, # output to screen every 180 timesteps
				   integration = "runge_kutta", # Use 3rd Order
				   rk_stage_user = 3,           # RK time-stepping
				   smooth = 0, # No smoothing
				   limiter_option = 4, # Use lim4
				   io_stride = 1, # Keep output consistent with swtc1.sh
				   filter_mu = 0.005, # Doesn't matter, since filter_freq = 0
				   s_bv = 0.80,       # But makes output consistent w/ swtc1.sh
				   output_varnames1 = ["geop"], # Only output geopotential height
				   output_frequency = 12, # Keep output consistent with swtc1.sh
				   interp_nlon = 256, # interpolate output onto a
				   interp_nlat = 128, # 256 x 128 grid
				   out_dir = out_dir, # output to directory specified above
				   exe="sweqx") # setup output for shallow water tests

# (5) Run HOMME
homme.execute(exe="sweqx", # run shallow water SEM executable
			  bld_dir = bld_dir, # location of executable
			  out_dir = out_dir, # output to directory specified above
			  ncpu = 16) # run on this many cores
