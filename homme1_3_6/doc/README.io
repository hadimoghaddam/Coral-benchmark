A number of options exist for the generation of netcdf output analysis
files.  An option is selected at compile time by setting the MOVIES
variable in the file Params.inc to one of the following values:

1. _NETCDF this uses the standard sequential netcdf i/o library to
   produce individual output files for each mpi task.  Since this 
   requires no communication it is usually the best performing method.
   However this method requires substantial postprocessing to get it
   into a form that analysis tools can read.  Tested at netcdf version 3.6.2 
   Requires external library Netcdf available at 
   http://www.unidata.ucar.edu/software/netcdf/

2. _PNETCDF uses the Argonne National Labs parallel implimentation of 
   netcdf to produce a single output file.  This makes postprocessing easy
   but limitations of the implimentation make this a poor performer.
   Tested at version parallel-netcdf-1.0.2pre2
   Requires external library pnetcdf available at 
   http://www-unix.mcs.anl.gov/parallel-netcdf/

3. _PIO overcomes the limitations of pnetcdf by rearranging data prior to
   calling that layer.  There is a substantial improvement in performance 
   over pnetcdf alone.
   Requires external library PIO, PIO is in subdirectory ./utils/pio but
   must be built seperately.

4  _PIO_INTERP performs a high order interpolation of the data to a lat lon
   grid prior to output.  This method requires the least amount of data 
   postprocessing prior to analysis.
   Requires external library PIO, PIO is in subdirectory ./utils/pio but
   must be built seperately.  This option should also be set to use the 
   standalone interpolation program outlined below.

Namelist description:
   The namelist for control of io is called analysis_nl.  Up to 5 seperate 
   output files are possible.  Variables with a (5) at the end are controlable
   for each file.

         output_prefix: prefix this string to the output filename 
         output_timeunits(5): 0 - steps
                           1 - days
                           2 - hours
         output_start_time(5): Time to start output in units of output_timeunits

         output_end_time(5): Time to end output in units of output_timeunits
         output_frequency(5): frequency of output in units of output_timeunits
         output_dir: directory for file output (default ./movies)
#ifdef PIO 
	io_stride:    Stride between IO tasks
	num_io_procs: Number of tasks to use for IO
#endif
#ifdef PIO_INTERP
	nlat:   Number of latitudes in interpolated grid (64)
        nlon:   Number of longitudes in interpolated grid (128)
        gridtype:   1       equally spaced, including point at the pole
                    2       Gauss grid (CAM Eulerian)  (default)
                    3       CAM FV grid  
	infilenames: For the standalone interpolation mode - the input cubed sphere files
                     to interpolate to a lat/lon grid.
	vector_uvars: For the standalone interpolation mode - the names of variables to be
                      used as u, v pairs and interpolated using the vector interpolation
                      algorythm instead of the default scalar algorythm.
	vector_vvars: See vector_uvars above.  There must be a vector_vvar listed for each
                      vector_uvar.
#endif
         output_varnames1,    
         output_varnames2,    
         output_varnames3,    
         output_varnames4,    
         output_varnames5 : Names of variables to write to each file.


New 9/24/2007 Standalone interpolation mode.
  This mode is used to interpolate files output on the native cubed sphere grid to a lat/lon 
  grid using the basis functions.    To use this mode you need to run the preqx executable with
  the ctl_nl runtype namelist option set to -1.  You must also include at least one input filename
  in the  analysis_nl variable infilenames.  In can be used for files output from the homme model 
  or from the cam model run with the homme dycore.  

 

