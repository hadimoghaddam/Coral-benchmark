import os,commands,sys,math
import globalvars

def get_nu_tstep(ne=None,ref=None,hypervis_power=None,test_case=None):
	# Currently returns nu and dt for SEM (sweqx and preqx)
	# Assumes np = 4; test_case is needed because swtc1
	# Should use a larger timestep

	# Error out for the following:
	## ne not specified
	## test_case not specified
	## hypervis_power not specified (except for swtc1 and Polvani)
	try:
		if ne is None:
			raise Exception("NoNE")
		if test_case is None:
			raise Exception("NoTest_Case")
		if (hypervis_power is None) and (test_case is not "swtc1") and \
		   (test_case is not "baroclinic"):
			raise Exception("NoHVP")
	except Exception as err:
		if str(err) is "NoNE":
			print "ERROR: get_nu_tstep() -- you must specify ne"
		elif str(err) is "NoTest_Case":
			print "ERROR: get_nu_tstep() -- you must specify test_case"
		elif str(err) is "NoHVP":
			print "ERROR: get_nu_tstep() -- you must specify hypervis_power" + \
				  " for " + test_case + " test case"
		else:
			print "ERROR: get_nu_tstep() -- Exception = "+str(err)
		sys.exit(0)

	nu = None
	tstep = None
	fine_ne = ne*ref

	if test_case is "swtc1":
		tstep = 4800./fine_ne
		return([0, tstep])

	tstep = 2700./fine_ne

	if test_case is "swtc5":
		tstep = 0
		if fine_ne is 6:
			tstep = 200
		elif fine_ne is 10:
			tstep = 200
		elif fine_ne is 12:
			tstep = 120
		elif fine_ne is 15:
			tstep = 80
		elif fine_ne is 20:
			tstep = 50
		elif fine_ne is 30:
			tstep = 20
		elif fine_ne is 40:
			tstep = 12.5
		elif fine_ne is 60:
			tstep = 5
		elif fine_ne is 80:
			tstep = 3.125
		elif fine_ne is 96:
			tstep = 1.875
		elif fine_ne is 120:
			tstep = 1.28
		elif fine_ne is 160:
			tstep = 0.75
		elif fine_ne is 240:
			tstep = 0.32
		try:
			if tstep is 0:
				raise Exception("NoTstep")
		except Exception as err:
			if str(err) is "NoTstep":
				print "Error: get_nu_tstep(() -- invalid ne for swtc5!"
			else:
				print "ERROR: get_nu_tstep() -- Exception = "+str(err)
			sys.exit(0)

	if test_case is "baroclinic":
	# Polvani testcase specifies nu = 7e5
	# (Uses viscosity, NOT hyperviscosity)
		return([7e5, tstep])

	if hypervis_power is 0:
		nu = 1e16*(10**(math.log(15./ne)/math.log(2)))
	else:
		# Calculate nu based on smallest scale
		if hypervis_power is 4:
			nu = 1.024e15*((30./fine_ne)**4)
		else:
			#nu = 1e15*(10**(math.log(30./fine_ne)/math.log(2)))
			nu = 1e15*((30./fine_ne)**(math.log(10)/math.log(2)))

		# Adjust so this value occurs at largest elements of fine region
		nu = nu/((4./3.)**(hypervis_power/2.))
		# Adjust again so we get nu appropriate on coarse grid
		# (not necessary because we sent HOMME nu and fine_ne!!!)
#		nu = nu*((ref**(math.log(10)/math.log(2)))/(ref**hypervis_power))

	nu = float('%10.4e' % nu)
	return([nu, tstep])


def get_mesh(refine,ne,ref,smth=None):
	# Currently the naming convention for grids is
	# {refine}_{ne}_x{ref}[-s{smth}].g, where {} denote
	# variable names and [] is only used for smth>0

	if ref < 2:
		mesh = "uniform_"+str(ne)
	else:
		mesh = refine+"_"+str(ne)+"_x"+str(ref)
		if (smth is not None) and (smth is not 0):
			mesh = mesh+"_s"+str(smth)
	return(mesh)

def find_mesh(mesh):
	# Given a mesh name, looks in $HOMME/test/mesh_refine/grids for it
	# ($HOMME is actually globalvars.homme_dir 
	mesh_file = os.path.expanduser(globalvars.homme_dir) + \
				"/test/mesh_refine/grids" + "/"+mesh+".g"
	try:
		if os.path.isfile(mesh_file) is False:
			raise Exception("NoMesh")
	except Exception as err:
		if str(err) is "NoMesh":
			print "ERROR -- find_mesh(): Can not find "+mesh_file
		sys.exit(0)

	return(mesh_file)

def set_tc_specific(test_case):
	# Determines what type of refinement to use based on testcase.

	try:
		if test_case is "swtc1":
			refine = "equator"
			ndays = 12
			plev = 4
		elif test_case is "swtc2":
			refine = "quadrant"
			ndays = 5
			plev = 1
		elif test_case is "swtc5":
			refine = "mountain"
			ndays = 15
			plev = 1
		elif test_case is "baroclinic":
			refine = "north"
			ndays = 12
			plev = 20
		elif test_case is "jw_baroclinic":
			refine = "north"
			ndays = 30
			plev = 26
		else:
			raise Exception("BadTest")
	except Exception as err:
		if str(err) is "BadTest":
			print "ERROR -- set_tc_specific(): " + '"' + test_case + '"' + \
			      " is not a valid choice for test_case!"
		sys.exit(0)

	return([refine,ndays,plev])

def set_mpirun(ncpu):
	# Determines how to launch MPI jobs (mpirun vs mpiexec vs ???). 
	# Currently just checking between two Sandia machines, but please
	# add to this!

	if commands.getoutput("echo $SLURM_NNODES") is not '':
		# running on redsky at Sandia
		mpirun = "mpiexec --npernode 8 numa_wrapper --ppn 8"
	else:
		# running on climate at Sandia?
		mpirun = "mpirun -np "+str(ncpu)
	return(mpirun)

def get_bld_and_out_dirs(exe=None,subdir=None):
	# exe is the executable you wish to build (eg "swdgx" or "preqx")
	# subdir is an (optional) sub-directory of the default output dir
	try:
		if exe is None:
			raise Exception("NoEXE")
	except Exception as err:
		if str(err) is "NoEXE":
			print "ERROR -- get_bld_and_out_dirs(): " + \
				  "must specify executable you wish to build"
			sys.exit(0)
		
	# Set build directory
	# Will use $HOMME_BLD/{exe} if it exists, otherwise
	# value comes from test/python/globalvars.py
	bld_dir = commands.getoutput("echo $HOMME_BLD")
	if bld_dir is '':
		bld_dir = globalvars.default_bld_dir
	bld_dir = bld_dir+"/"+exe

	# Outdir is where output will be saved
	# Will use $HOMME_OUT if it exists, otherwise value comes from
	# test/python/globalvars.py
	out_dir = commands.getoutput("echo $HOMME_OUT")
	if out_dir is '':
		out_dir = globalvars.default_out_dir
	if subdir is not None:
		out_dir = out_dir + "/" + subdir

	bld_dir = os.path.expanduser(bld_dir)
	out_dir = os.path.expanduser(out_dir)
	return([bld_dir,out_dir])

def nclexe(exe=None,out_dir=None,append=None):
	# Run the NCL script given in {exe} from {out_dir}

	try:
		if  exe is None:
			raise Exception("NoEXE")
		if out_dir is None:
			raise Exception("NoOut_Dir")
		exe = os.path.expanduser(exe)
		if os.path.isfile(exe) is False:
			raise Exception("EXEnotFound")
		out_dir = os.path.expanduser(out_dir)
		if os.path.isdir(out_dir) is False:
			raise Exception("OutDirNotFound")
	except Exception as err:
		if str(err) is "NoEXE":
			print "ERROR -- nclexe(): must specify NCL script to run"
		elif str(err) is "NoOut_Dir":
			print "ERROR -- nclexe(): must specify where to run NCL script"
		elif str(err) is "EXEnotFound":
			print "ERROR -- nclexe(): " + exe + " does not exist"
		elif str(err) is "OutDirNotFound":
			print "ERROR -- nclexe(): " + out_dir + " does not exist"
		sys.exit(0)

	if append:
		suffix = " | tee -a homme.out"
	else:
		suffix = ""

	os.chdir(out_dir)
	os.system("rm -rf ncl_exe.ncl")
	os.system("ln -s " + exe + " ./ncl_exe.ncl")
	os.system("ncl ncl_exe.ncl" + suffix)
				

