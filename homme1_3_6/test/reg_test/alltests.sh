#!/bin/tcsh -f

# Notes
# -----
# 1. this script does not run baro-dg.sh because it requires
#    orders of magnitude more time / processing power
#
# 2. As of rev 1473 (Apr 27, 2011), this script takes ~45 min
#    on 4 nodes of blackrose (quad-core 2.8 Ghz AMD w/ 8 GB RAM
#    and Infiniband interconnect) => 16 cores total
#
# 3. Use "-t" or "-t $OUT_FILE" to output timing info (if not
#    specified, output to timing.out)

if ( $?1 ) then
	if ( "$1" == "-t" ) then
		set TIMING = "TRUE"
		if ( $?2 ) then
			set TIMING_FILE = ../$2
		else
			set TIMING_FILE = ../timing.out
		endif
	endif
endif

if ( ! $?TIMING ) then
	set TIMING = "FALSE"
endif

cd individual_tests
if ( "$TIMING" == "TRUE" ) then
	echo Starting sweqx > $TIMING_FILE
	date | tee -a $TIMING_FILE
	echo >> $TIMING_FILE
endif
./swtc1.sh # NP = 8, PLEV = 4 
./swtc5.sh # NP = 4, PLEV = 1
./swtc6.sh # NP = 8, PLEV = 1
if ( "$TIMING" == "TRUE" ) then
	echo Starting swdgx >> $TIMING_FILE
	date | tee -a $TIMING_FILE
	echo >> $TIMING_FILE
endif
./swtc1-dg.sh # NP = 6, PLEV = 1
./swtc2-dg.sh # NP = 6, PLEV = 1
./swtc5-dg.sh # NP = 6, PLEV = 1
if ( "$TIMING" == "TRUE" ) then
	echo Starting preqx >> $TIMING_FILE
	date | tee -a $TIMING_FILE
	echo >> $TIMING_FILE
endif
./baro1a.sh # NP = 8, PLEV = 20
./baro1b.sh # NP = 8, PLEV = 20
./baro2a.sh # NP = 4, PLEV = 26
./baro2b.sh # NP = 4, PLEV = 26
./baro2c.sh # NP = 4, PLEV = 26
if ( "$TIMING" == "TRUE" ) then
	echo Done >> $TIMING_FILE
	date | tee -a $TIMING_FILE
endif
