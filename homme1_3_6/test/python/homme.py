# A set of python routines used to test HOMME
# Contains the following:
## config() -- check the current configuration of HOMME, reconfigure if
##             necessary. It calls the following two routines:
##     runconfig() -- actually run configure in $HOMME/build/{exe}
##                    (also makes dependencies)
##     build() -- makes the HOMME executable
##
## makenamelist() -- constructs the namelist for HOMME to read in.
##                   It calls the following two routines:
##     addquotes() -- given a string, returns "{string}"
##     addquotes_vec() -- same as above, but for a vector of strings
##
## execute() -- launches the HOMME executable
##

import os,commands,sys
import globalvars,homme_utils

def config(exe=None,np=None,plev=None,pio=None,mesh=None,bld_dir=None):
# Use configure in {bld_dir} to build {exe}. Can set NP, PLEV, PIO, and MESH

	# Error out for following conditions:
	## {exe} not specified
	## {bld_dir} not specified
	try:
		if exe is None:
			raise Exception("NoEXE")
		if bld_dir is None:
			raise Exception("NoBldDir")
	# Handle errors from above conditions
	except Exception as err:
		if str(err) is "NoEXE":
			print "ERROR: config() -- specify an executable when calling config()" 
		elif str(err) is "NoBldDir":
			print "ERROR: config() -- you must specify where to build HOMME"
		else:
			print "ERROR: config() -- Exception = "+str(err)
		sys.exit(0)

	# Define np, plev, pio, and mesh if they are not specified
	if np is None:
		np = 4
	if plev is None:
		if exe is 'sweqx':
			plev = 1
		else:
			plev = 26

	# For pio and mesh, 1 = True and '' = False
	# (unspecified => False)
	if ((str(pio) is "True") or (pio is 1)):
		pio = 1
	else:
		pio = ''
	if ((str(mesh) is "True") or (mesh is 1)):
		mesh = 1
	else:
		mesh = ''

	# Save all variables as strings
	np = str(np)
	plev = str(plev)
	pio = str(pio)
	mesh = str(mesh)
	# Expand bld_dir in case it contains '~/'
	bld_dir=os.path.expanduser(bld_dir)

	# Error out for following conditions:
	##	{bld_dir} directory does not exist
	## configure file not present in {bld_dir}
	try:
		if os.path.isdir(bld_dir):
			os.chdir(bld_dir)
			bld_dir=commands.getoutput("echo $PWD")
			if os.path.isfile("config.log"):
				# If configure has already been run, check the setup to see if
				# needs to be run again
				print "config.log exists, checking variables..."
				curNP = commands.getoutput\
						("sed -n 's/#define NP \([0-9]\)/\\1/p' config.log")
				curPLEV = commands.getoutput\
						  ("sed -n 's/#define PLEV \([0-9]\)/\\1/p' config.log")
				curPIO = commands.getoutput\
						 ("sed -n 's/#define PIO \([0-9]\)/\\1/p' config.log")
				curMESH = commands.getoutput\
						  ("sed -n 's/#define MESH \([0-9]\)/\\1/p' config.log")

				if (np == curNP) and (plev == curPLEV) and \
				   (pio == curPIO) and (mesh == curMESH):
					# If  NP, PLEV, MESH, and PIO are set correctly, just
					# rebuild the executable (in case source has changed)
					print "...no need to reconfigure!"
					build(exe=exe)
				else:
					# If one or more of the above has been changed, need
					# to re-run configure
					print "... current settings differ from previous config!"
					runconfigure(exe=exe,np=np,plev=plev,pio=pio,mesh=mesh)
			else:
				# If configure has not been run, check to see if it exists
				if os.path.isfile("configure"):
					# If configure exists, run it!
					print "Found configure, but no config log!"
					runconfigure(exe=exe,np=np,plev=plev,pio=pio,mesh=mesh)
				else:
					raise Exception('ConfigureNotFound')
		else:
			raise Exception('DirNotFound')
	# Handle errors from above conditions
	except Exception as err:
		if str(err) is "ConfigureNotFound":
			print "ERROR: config() -- There is no configure script in "+bld_dir
		elif str(err) is 'DirNotFound':
			print "ERROR: config() -- Build directory "+bld_dir+" not found!"
		else:
			print "ERROR (need to add to exception list): "+str(err)
		sys.exit(0)


def runconfigure(exe=None,np=None,plev=None,pio=None,mesh=None):
# config() checked to make sure configure exists
# runconfigure actually runs it
# Note: this routine does not have any error checks in it

	# Default options (perhaps move this to globalvars?)
	options = "--enable-lapack --enable-blas --with-netcdf=" + \
			  globalvars.netcdf_dir + " --with-pnetcdf=" + \
			  globalvars.pnetcdf_dir+ " NP=" + np + " PLEV=" + plev

	# Additional option if running on OS X
	if (commands.getoutput("uname") == 'Darwin'):
		options = options + " --with-arch=Darwin"

	# Additional option if outputting to native grid
	if pio is "1":
		options = options + " --enable-pio"

	# Additional option if using exodus mesh files
	if mesh is "1":
		options = options + " --enable-mesh-refine"

	# Remove any old dependencies from last build
	if os.path.isfile("Makefile"):
		print "Cleaning up old build..."
		os.system("make distclean")

	# Run configure
	os.system("./configure "+options)
	# Make dependencies
	os.system("make -j 4 depends")
	# Build HOMME
	build(exe=exe)

def build(exe=None):
# Build HOMME executable
# Note: this routine does not have any error checks in it

	# Delete old executable (if it exists)
	os.system("rm -rf "+exe)
	# Make new executable
	os.system("make "+globalvars.make_opt)

def makenamelist(NThreads=None, partmethod=None,topology=None,test_case=None,\
				 ne=None,fine_ne=None,qsize=None,ndays=None,statefreq=None,\
				 accumfreq=None,accumstart=None,accumstop=None,tasknum=None,\
				 restartfreq=None,restartfile=None,runtype=None,tstep=None,\
				 energy_fixer=None,integration=None,rk_stage_user=None,\
				 tracer_advection_formulation=None,\
				 LFTfreq=None,smooth=None,limiter_option=None,u_perturb=None,\
				 nu=None,nu_s=None,nu_p=None,nu_q=None,nu_top=None,\
				 hypervis_order=None,hypervis_subcycle=None,hypervis_power=None,\
				 max_hypervis_courant=None,mesh_file=None,precon_method=None,\
				 maxits=None,tol=None,transfer_type=None,filter_type=None,\
				 filter_freq=None,filter_mu=None,p_bv=None,s_bv=None,\
				 wght_fm=None,kcut_fm=None,vform=None,vfile_mid=None,\
				 vfile_int=None,interp_gridtype=None,interp_type=None,\
				 output_start_time=None,output_end_time=None,\
				 output_timeunits=None,output_frequency=None,\
				 output_varnames1=None,io_stride=None,output_type=None,\
				 interp_nlat=None,interp_nlon=None,riemanntype=None,\
				 alphatype=None,alpha_dg=None,plev=None,exe=None,out_dir=None):
# Build namelist for {exe}, store it in {out_dir}

	# Error out for following conditions:
	## {exe} not specified
	## {out_dir} not specified
	## {exe} = "preqx" and {plev} not specified (for vcoord files)
	## {test_case} not specified
	## non-numeric {ne} (can't reduce it to int)
	## {ndays} not specified
	## {statefreq} not specifed
	## {tstep} not specified
	## {ne}=0 and {mesh_file}='none'
	try:
		if exe is None:
			raise Exception("NoEXE")
		if out_dir is None:
			raise Exception("NoOutDir")
		if (exe is "preqx") and (plev is None):
			raise Exception("NoPLEV")
		if test_case is None:
			raise Exception("NoTestcase")
		if ne is None:
			ne = 0
		elif ne is str(ne):
			raise Exception("StrNE")
		ne = int(ne)
		if ndays is None:
			raise Exception("NoNDAYS")
		if statefreq is None:
			raise Exception("NoStateFreq")
		if tstep is None:
			raise Exception("NoTstep")
		if mesh_file is None:
			if (ne < 1):
				raise Exception("NoMesh")
			else:
				mesh_file = "none"
	# Handle Errors in the routine
	except Exception as err:
		if str(err) is "NoEXE":
			print "ERROR: runconfigure() -- specify which executable you are building"
		elif str(err) is "NoOutDir":
			print "ERROR: runconfigure() -- specify where to save namelist"
		elif str(err) is "NoPLEV":
			print "ERROR: runconfigure() -- specify plev to build preqx namelist"
		elif str(err) is "NoTestcase":
			print "ERROR: runconfigure() -- specify a testcase when making a namelist"
		elif str(err) is "StrNE":
			print "ERROR: runconfigure() -- specify a numerical value for ne"
		elif str(err) is "NoNDAYS":
			print "ERROR: runconfigure() -- specify ndays when making a namelist"
		elif str(err) is "NoStateFreq":
			print "ERROR: runconfigure() -- specify statefreq when making a namelist"
		elif str(err) is "NoTstep":
			print "ERROR: runconfigure() -- specify tstep when making a namelist"
		elif str(err) is "NoMesh":
			print "ERROR: runconfigure() -- specify either ne>0 or a mesh file"
		else:
			print "ERROR runconfigure() -- Exception = "+str(err)
		sys.exit(0)

	# Make sure directory for namelist exists (also create movie directory)
	if os.path.isdir(out_dir+"/movies") is False:
		print "Can not find "+out_dir+"/movies... creating it now"
		os.system("mkdir -p "+out_dir+"/movies")

	# Default values for anything un-specified in call to routine
	## ctl_nl
	if NThreads is None:
		NThreads = 1
	if partmethod is None:
		partmethod = 4
	if topology is None:
		topology = "cube"
	if qsize is None:
		qsize = 0
	if accumfreq is None:
		accumfreq = -1
	if accumstart is None:
		accumstart = 300
	if accumstop is None:
		accumstop = 600
	if tasknum is None:
		tasknum = 0
	if restartfreq is None:
		restartfreq = -1
	if restartfile is None:
		restartfile = "./restart/R000001"
	if runtype is None:
		runtype = 0
	if energy_fixer is None:
		energy_fixer = 0
	if integration is None:
		integration = "explicit"
	if integration is "runge_kutta":
		UseRK = True
		if rk_stage_user is None:
			rk_stage_user = 4
	else:
		UseRK = False
	if LFTfreq is None:
		LFTfreq = 0
	if smooth is None:
		if exe is "sweqx":
			smooth = 0.05
		else:
			smooth = 0.005
	if nu is None:
		nu = 0
	if nu_s is None:
		nu_s = 0
	if nu_p is None:
		nu_p = 0
	if hypervis_order is None:
		hypervis_order = 2
	if hypervis_power is None:
		hypervis_power = 0
	if u_perturb is None:
		u_perturb = 1

	## solver_nl
	if precon_method is None:
		precon_method = "identity"
	if maxits is None:
		maxits = 100
	if tol is None:
		tol = "1e-9"

	## filter_nl
	if filter_type is None:
		filter_type = "taylor"
	if transfer_type is None:
		transfer_type = "bv"
	if filter_freq is None:
		filter_freq = 0
	if filter_mu is None:
		filter_mu = "0.05d0"
	if p_bv is None:
		p_bv = "12.0d0"
	if s_bv is None:
		s_bv = ".666666666666666666d0"
	if wght_fm is None:
		wght_fm = "0.1d0"
	if kcut_fm is None:
		kcut_fm = 2

	## vert_nl (3D only!)
	if (exe is "preqx"):
		# Copy vcoord directory over
		## Use sabm- and sabi- for Polvani
		## Use camm- and cami- for JW
		if test_case is "baroclinic":
			prefix = "sab"
		else:
			prefix = "cam"
		os.system("rsync -a " + globalvars.default_vcoord_dir +"/*" + \
				  str(plev) + "* " + out_dir + "/vcoord")
		if vform is None:
			vform = "ccm"
		if vfile_mid is None:
			vfile_mid = "vcoord/" + prefix + "m-" + str(plev) + ".fbin"
			if commands.getoutput("uname") is not "AIX":
				vfile_mid = vfile_mid+".littleendian"
		if vfile_int is None:
			vfile_int = "vcoord/" + prefix + "i-" + str(plev) + ".fbin"
			if commands.getoutput("uname") is not "AIX":
				vfile_int = vfile_int+".littleendian"

	## analysis_nl
	if interp_gridtype is None:
		interp_gridtype = 2
	if interp_type is None:
		interp_type = 0
	if output_start_time is None:
		output_start_time = 0
	if output_end_time is None:
		output_end_time = -1
	if output_timeunits is None:
		output_timeunits = 1
	if output_frequency is None:
		output_frequency = 1
	if output_varnames1 is None:
		output_varnames1 = ["geop","zeta"]
	output_analysis = (output_varnames1 is not '')
	if output_type is None:
		output_type = "netcdf"
	if io_stride is None:
		io_stride = 8
	if interp_nlat is None:
		interp_nlat = 180
	if interp_nlon is None:
		interp_nlon = 360

	## dg_nl
	if riemanntype is None:
		riemanntype = 0
	if alphatype is None:
		alphatype = 4
	if alpha_dg is None:
		alpha_dg = "0.0d0"

	print "Building namelist for "+exe

	os.chdir(out_dir)
	# If input.nl already exists in out_dir, delete it!
	os.system("rm -rf input.nl")
	# Write the namelist (input.nl in out_dir)
	namelist=open("input.nl","w")
	namelist.write("&ctl_nl\n")
	write_to_file("NThreads",NThreads,namelist)
	write_to_file("partmethod",partmethod,namelist)
	write_to_file("topology",addquotes(topology),namelist)
	write_to_file("test_case",addquotes(test_case),namelist)
	write_to_file("ne",ne,namelist)
	if fine_ne is not None:
		write_to_file("fine_ne",fine_ne,namelist)
	if exe is "preqx":
		write_to_file("qsize",qsize,namelist)
	write_to_file("ndays",ndays,namelist)
	namelist.write("statefreq            = "+str(statefreq)+"\n")
	namelist.write("accumfreq            = "+str(accumfreq)+"\n")
	namelist.write("accumstart           = "+str(accumstart)+"\n")
	namelist.write("accumstop            = "+str(accumstop)+"\n")
	if exe is "sweqx":
		namelist.write("tasknum              = "+str(tasknum)+"\n")
	namelist.write("restartfreq          = "+str(restartfreq)+"\n")
	write_to_file("restartfile",addquotes(restartfile),namelist)
	namelist.write("runtype              = "+str(runtype)+"\n")
	namelist.write("tstep                = "+str(tstep)+"\n")
	if (exe is "preqx") and (energy_fixer is not ''):
		namelist.write("energy_fixer         = "+str(energy_fixer)+"\n")
	write_to_file("integration",addquotes(integration),namelist)
	if tracer_advection_formulation is not None:
		namelist.write("tracer_advection_formulation = "+\
					   str(tracer_advection_formulation)+"\n")
	if UseRK:
		namelist.write("rk_stage_user        = "+str(rk_stage_user)+"\n")
	if exe is "sweqx":
		# ASK MARK ABOUT WHEN TO USE LFTfreq!!!!
		namelist.write("LFTfreq              = "+str(LFTfreq)+"\n")
	namelist.write("smooth               = "+str(smooth)+"\n")
	if limiter_option is not None:
		namelist.write("limiter_option       = "+str(limiter_option)+"\n")
	if (exe is "preqx") and (u_perturb is not ''):
		namelist.write("u_perturb            = "+str(u_perturb)+"\n")
	namelist.write("nu                   = "+str(nu)+"\n")
	namelist.write("nu_s                 = "+str(nu_s)+"\n")
	if (exe is "preqx") and (nu_p is not ''):
		namelist.write("nu_p                 = "+str(nu_p)+"\n")
		if nu_q is not None:
			namelist.write("nu_q                 = "+str(nu_q)+"\n")
		if nu_top is not None:
			namelist.write("nu_top               = "+str(nu_top)+"\n")
	namelist.write("hypervis_order       = "+str(hypervis_order)+"\n")
	if hypervis_subcycle is not None:
		namelist.write("hypervis_subcycle    = "+str(hypervis_subcycle)+"\n")
	namelist.write("hypervis_power       = "+str(hypervis_power)+"\n")
	if max_hypervis_courant is not None:
		namelist.write("max_hypervis_courant = "+str(max_hypervis_courant)+"\n")
	write_to_file("mesh_file",addquotes(mesh_file),namelist)
	namelist.write("/\n")
	namelist.write("&solver_nl\n")
	write_to_file("precon_method",addquotes(precon_method),namelist)
	namelist.write("maxits        = "+str(maxits)+"\n")
	namelist.write("tol           = "+str(tol)+"\n")
	namelist.write("/\n")
	namelist.write("&filter_nl\n")
	write_to_file("transfer_type",addquotes(transfer_type),namelist)
	write_to_file("filter_type",addquotes(filter_type),namelist)
	namelist.write("filter_freq   = "+str(filter_freq)+"\n")
	namelist.write("filter_mu     = "+str(filter_mu)+"\n")
	namelist.write("p_bv          = "+str(p_bv)+"\n")
	namelist.write("s_bv          = "+str(s_bv)+"\n")
	namelist.write("wght_fm       = "+str(wght_fm)+"\n")
	namelist.write("kcut_fm       = "+str(kcut_fm)+"\n")
	namelist.write("/\n")
	if exe is "preqx":
		namelist.write("&vert_nl\n")
		write_to_file("vform",addquotes(vform),namelist)
		write_to_file("vfile_mid",addquotes(vfile_mid),namelist)
		write_to_file("vfile_int",addquotes(vfile_int),namelist)
		namelist.write("/\n")
	namelist.write("&analysis_nl\n")
	namelist.write("output_timeunits  = "+str(output_timeunits)+"\n")
	namelist.write("output_frequency  = "+str(output_frequency)+"\n")
	if output_analysis:
		if interp_gridtype is not '':
			namelist.write("interp_gridtype   = "+str(interp_gridtype)+"\n")
		namelist.write("interp_type       = "+str(interp_type)+"\n")
		if output_start_time is not '':
			namelist.write("output_start_time = "+str(output_start_time)+"\n")
		if output_end_time is not '':
			namelist.write("output_end_time   = "+str(output_end_time)+"\n")
		write_to_file("output_varnames1",addquotes_vec(output_varnames1),namelist)
		namelist.write("io_stride         = "+str(io_stride)+"\n")
		write_to_file("output_type",output_type,namelist)
		if (interp_nlat is not '') and (interp_nlon is not ''):
			namelist.write("interp_nlat       = "+str(interp_nlat)+"\n")
			namelist.write("interp_nlon       = "+str(interp_nlon)+"\n")
	namelist.write("/\n")
	if (exe is "swdgx") or (exe is "primdgx"):
		namelist.write("&dg_nl\n")
		namelist.write("riemanntype = "+str(riemanntype)+"\n")
		namelist.write("alphatype   = "+str(alphatype)+"\n")
		namelist.write("alpha_dg    = "+str(alpha_dg)+"\n")
		namelist.write("/\n")

def execute(exe=None,out_dir=None,bld_dir=None,ncpu=None):
# Run HOMME from out_dir

	# Error out for the following conditions:
	## {exe} not specified
	## {out_dir} not specified
	## {bld_dir} not specified
	## {bld_dir} doesn't exist
	## {exe} does not exist in {bld_dir}
	## {out_dir} does not exist
	## input.nl does not exist in {out_dir}
	try:
		if exe is None:
			raise Exception("NoEXE")
		if out_dir is None:
			raise Exception("NoOut_Dir")
		if bld_dir is None:
			raise Exception("NoBld_Dir")
		if os.path.isdir(bld_dir) is False:
			raise Exception("NoBldDir")
		if os.path.isfile(bld_dir+"/"+exe) is False:
			raise Exception("NoBldEXE")
		if os.path.isdir(out_dir) is False:
			raise Exception("NoOutDir")
		if os.path.isfile(out_dir+"/input.nl") is False:
			raise Exception("NoNML")
	except Exception as err:
		if str(err) is "NoEXE":
			print "ERROR: execute() -- you must specify which executable you are running"
		elif str(err) is "NoOut_Dir":
			print "ERROR: execute() -- you must specify where to store output"
		elif str(err) is "NoBld_Dir":
			print "ERROR: execute() -- you must specify where HOMME was built"
		elif str(err) is 'NoBldDir':
			print "ERROR: execute() -- Build directory "+bld_dir+" not found!"
		elif str(err) is 'NoBldEXE':
			print "ERROR: execute() -- Cannot find "+exe+" in "+bld_dir
		elif str(err) is "NoOutDir":
			print "ERROR: execute() -- Cannot copy "+exe+" to "+out_dir + \
				  " because that directory does not exist"
		elif str(err) is "NoNML":
			print "ERROR: execute() -- output directory does not contain namelist!"
		else:
			print "ERROR: execute() -- Exception = "+str(err)
		sys.exit(0)

	# If ncpu is not specified, use default value
	if ncpu is None:
		ncpu=globalvars.default_ncpu
	# set up proper command to launch parallel job
	mpirun = homme_utils.set_mpirun(ncpu)	

	os.chdir(out_dir)
	os.system(mpirun + " "+bld_dir + "/" + exe + " < input.nl | tee homme.out")

#####################################

def addquotes(str_in):
# Add " " around a given string
	return('"'+str(str_in)+'"')

def addquotes_vec(str_in):
# Add " " around every element in a vector, return comma-delimited list
# (So single string, not a vector of strings)
	result = ''
	for i in range(len(str_in)):
		result = result+addquotes(str_in[i])
		if (i < len(str_in)-1):
			result = result + ", "
	return(result)

def write_to_file(var_name, var_value, file_name):
	if var_value is not '':
		file_name.write(var_name+" = "+str(var_value)+"\n")
