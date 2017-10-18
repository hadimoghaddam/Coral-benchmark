#!/usr/bin/env python

## A basic python script to build and run HOMME; note that there are only 5
## function calls, most of the hard work is done in homme.py and homme_utils.py

## (1) Import python routines from homme.py and homme_utils.py
##   The commented lines below are needed if this script is not in the same
##   directory as those two files
#import sys,os
#sys.path.append(os.path.expanduser("../python"))
import homme,homme_utils

## (2) build sweqx, output to default_out/example
##    you can either change the default_bld_dir and default_out_dir variables
##    in globalvars.py or you can set $HOMME_BLD and $HOMME_OUT
[bld_dir, out_dir] = homme_utils.get_bld_and_out_dirs("sweqx","example")

## (3) Configure and Build HOMME
##    pio and mesh will default to False so they are un-necessary.
##    Also, if np defaults to 4 and plev will be set according to your
##    choice of exe (1 for sweqx, 26 for anything else), so they may be
##    omitted as well. exe is required.
homme.config(exe="sweqx", # Want shallow water SEM executable
			 bld_dir=bld_dir, # Where to build executable
			 np=4, # 4 x 4 GLL nodes on each element
			 plev=1, # Only 1 vertical level
			 pio=False, # Interpolate output, don't output on native grid
			 mesh=False) # Do not need to read an Exodus mesh file

## (4) Generate namelist
##    Note that any variable that can be adjusted in the namelist is an
##    allowable argument, but the majority of them can be set to default
##    values or omitted entirely. If a variable _is_ missing, please add
##    it to the makenamelist routine in homme.py
homme.makenamelist(test_case = "swtc2", # steady-state flow
				   ne = 10, # uniform cube-sphere mesh (10x10x6)
				   ndays = 5, # run for 5 days
				   nu = 0, # no viscosity
				   tstep = 270, # 270s timestep
				   statefreq = 320, # output to screen every 320 timesteps
				   interp_nlon = 256, # interpolate output onto a
				   interp_nlat = 128, # 256 x 128 grid
				   out_dir = out_dir, # output to directory specified above
				   exe="sweqx") # setup output for shallow water tests

# (5) Run HOMME
##   Everything except ncpu is required here, if omitted ncpu will be set to
##   globalvars.default_ncpu
homme.execute(exe="sweqx", # run shallow water SEM executable
			  bld_dir = bld_dir, # location of executable
			  out_dir = out_dir, # output to directory specified above
			  ncpu = 4) # run on this many cores
