SNAP: SN (Discrete Ordinates) Application Proxy
===============================================

A.) Description

SNAP is a proxy application to model the performance of a modern discrete 
ordinates neutral particle transport application. SNAP may be considered an 
update to Sweep3D, intended for hybrid computing architectures. It is 
modeled off the Los Alamos National Laboratory code PARTISN. PARTISN solves the 
linear Boltzmann transport equation (TE), a governing equation for determining 
the number of neutral particles (e.g., neutrons and gamma rays) in a multi 
dimensional phase space. SNAP itself is not a particle transport 
application; SNAP incorporates no actual physics in its available data, nor 
does it use numerical operators specifically designed for particle transport. 
Rather, SNAP mimics the computational workload, memory requirements, and 
communication patterns of PARTISN. The equation it solves has been composed to 
use the same number of operations, use the same data layout, and load elements 
of the arrays in approximately the same order. Although the equation SNAP 
solves looks similar to the TE, it has no real world relevance.

Problem Sizing
Running a time-dependent problem: This requires 2 copies of the angular flux 
('f' in the manual)--one for incoming, one for outgoing, of a time step. The 
angular flux arrays are sized by the number of cells (nx, ny, nz), the number 
of angles (8*nang), and the number of groups (ng). Memory requirements are as 
follows:
Memory in double precision words = 2 * (nx * ny * nz) * (8 * nang) * ng

Relevant problem ranges:
nx*ny*nz = ~1000-4000 per rank (MPI only) OR
           ~10000-20000 per rank (MPI + 'X')
nang = ~50-250
ng = ~30-100

All other arrays are significantly smaller than the angular flux arrays, hence 
estimating memory requirements for different calculations typically focuses on 
these arrays.

B.) How to Build SNAP:
SNAP requires a Fortran compiler at a minimum. The provided Makefile assumes by
this compiler features OpenMP capability. SNAP also is expected to be built with
MPI, another requirement of the system selected for deployment. The problems
described below all assume SNAP is built with MPI and OpenMP. To build SNAP:

(1) Untar the source
(2) cd SNAP/src
(3) Edit the Makefile for your compiler environment
(4) Make snap: 'make'. The executable, 'snap', will be in the src/ directory.

Enabling OpenMP requires no changes to the source code and requires no macros 
to be defined. Simply add the relevant compiler flag to the Makefile.

C.) How to run
Assuming SNAP was built with MPI, to execute SNAP, use the 
following command:

    mpirun -np [#] [path]/snap [infile] [outfile]

This command will automatically run with the number of threads specified by the 
input file, which is used to set the number of OpenMP threads, overwriting any 
environment variable to set the number of threads. Testing has shown that to 
ensure proper concurrency of work, the above command can be modified to

    mpirun -cpus-per-proc [#threads] -np [#procs] [path]/snap [infile] [outfile]

Users are encouraged to explore the appropriate settings for their system to
ensure concurrency and proper thread affinity.

The command line is read for the input/output file names. If one of the names 
is missing, the code will not execute. Moreover, the output file overwrites any 
pre-existing files of the same name.

For runs with OpenMP the OMP_NUM_THREADS shell variable must be set, 
additionally, the input deck includes a variable named "nthreads" which must 
also be set to something besides 1. Its default value is 1. This variable 
allows the user to specify using fewer than the number of threads specified by 
OMP_NUM_THREADS.

D.) Required Problems:
In the runs directory is the input files and output files for the following 
problems. Output files are from runs on NERSC Edison.
Small: in_s
Medium: in_m
Large: in_l
Extra-large: in_x
Grand Challenge: in_gc

MPI + OpenMP	ichunk=16								
Problem		npey	npez	nthreads	resources	nodes	nx	ny	nz
Small		2	2	6		24		1	160	16	24
Medium		12	12	6		864		36	160	96	144
Large		36	36	6		7776		324	160	288	432
Xtra-Large	72	144	6		62208		2592	320	576	864

The "Grand Challenge" problem has not been run, but has been posed as a
potential problem in the 5-year time frame.

A secondary problem has been created to reduce the iteration variation by fixing physical
domain size.

MPI + OpenMP	ichunk=32								
Problem		npey	npez	nthreads	resources	nodes	nx	ny	nz
Small		2	2	6		24		1	160	16	48
Medium		12	12	6		864		36	160	96	288
Large		36	36	6		7776		324	160	288	864
Xtra-Large	72	144	6		62208		2592	160	576	3456

E.) Verification:
If SNAP runs to completion you will see:
Success! Done in a SNAP! 

F.) Timing:
"Grind Time" needs to be reported for the procurement spreadsheet. Grind time
is an important performance metric, representing the time to solve for a single
phase-space variable--i.e., the angular flux of a a single cell, in a single
direction, for a single group, over one iteration (mesh sweep).

G.) Reporting:
Results are written to stdout and please include all output in separate files 
with unique names that can easily be associated with the required runs.

More Details

The solution to the time-dependent TE is a "flux" function of seven independent
variables: three spatial (3-D spatial mesh), two angular (set of discrete
ordinates, directions in which particles travel), one energy (particle speeds
binned into "groups"), and one temporal. PARTISN, and therefore SNAP, uses
domain decomposition over these dimensions to coherently distribute the data and
the tasks associated with solving the equation. The parallelization strategy is
expected to be the most efficient compromise between computing resources and the
iterative strategy necessary to converge the flux.

The iterative strategy is comprised of a set of two nested loops. These nested
loops are performed for each step of a time-dependent calculation, wherein any
particular time step requires information from the preceding one. No
parallelization is performed over the temporal domain. However, for time-
dependent calculations two copies of the unknown flux must be stored, each copy
an array of the six remaining dimensions. The outer iterative loop involves
solving for the flux over the energy domain with updated information about
coupling among the energy groups. Typical calculations require tens to hundreds
of groups, making the energy domain suitable for threading with the node's (or
nodes') provided accelerator. The inner loop involves sweeping across the
entire spatial mesh along each discrete direction of the angular domain. The
spatial mesh may be immensely large. Therefore, SNAP spatially decomposes the
problem across nodes and communicates needed information according to the KBA
method. KBA is a transport-specific application of general parallel
wavefront methods. Lastly, although KBA efficiency is improved by pipelining
operations according to the angle, current chipsets operate best with vectorized
operations. During a mesh sweep, SNAP operations are vectorized over angles to
take advantage of the modern hardware.

SNAP is written to the Fortran 95/2003 standard. Modules are used to provide
explicit interfacing among the different procedures. Distributed memory
communications are performed using MPI commands, and threading is achieved with
OpenMP pragmas. [See docs subdirectory for more detailed information

H.) Authorship
Los Alamos National Security, LLC owns the copyright to "SNAP: SN (Discrete 
Ordinates) Application Proxy, Version 1.x (C13087)". The license is BSD with 
standard clauses regarding indicating modifications before future 
redistribution:
Copyright (c) 2013, Los Alamos National Security, LLC
All rights reserved.
Copyright 2013. Los Alamos National Security, LLC. This software was produced 
under U.S. Government contract DE-AC52-06NA25396 for Los Alamos National 
Laboratory (LANL), which is operated by Los Alamos National Security, LLC for 
the U.S. Department of Energy. The U.S. Government has rights to use, 
reproduce, and distribute this software. NEITHER THE GOVERNMENT NOR LOS ALAMOS 
NATIONAL SECURITY, LLC MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY 
LIABILITY FOR THE USE OF THIS SOFTWARE. If software is modified to produce 
derivative works, such modified software should be clearly marked, so as not to 
confuse it with the version available from LANL.

Additionally, redistribution and use in source and binary forms, with or 
without modification, are permitted provided that the following conditions are 
met:

* Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.
* Neither the name of Los Alamos National Security, LLC, Los Alamos National 
Laboratory, LANL, the U.S. Government, nor the names of its contributors may be 
used to endorse or promote products derived from this software without specific 
prior written permission.

THIS SOFTWARE IS PROVIDED BY LOS ALAMOS NATIONAL SECURITY, LLC AND CONTRIBUTORS 
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL LOS ALAMOS NATIONAL SECURITY, LLC OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
OF SUCH DAMAGE.

General Mailing List
snap _ at _ lanl.gov

Joe Zerr, rzerr _ at _ lanl.gov
Randal Baker, rsb _ at _ lanl.gov

Classification
SNAP is Unclassified and contains no Unclassified Controlled Nuclear 
Information. It has been assigned Los Alamos Computer Code number LA-CC-13-016.
