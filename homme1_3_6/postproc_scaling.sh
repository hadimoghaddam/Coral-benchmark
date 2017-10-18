#!/bin/bash

 t1024=`grep "prim_run" /projects/Coral_rfp_prep/preqx.1024/jwasp-ne256-nu9.4e11/HommeTime  | awk '{print $4}'`
 t2048=`grep "prim_run" /projects/Coral_rfp_prep/preqx.2048/jwasp-ne256-nu9.4e11/HommeTime  | awk '{print $4}'`
 t4096=`grep "prim_run" /projects/Coral_rfp_prep/preqx.4096/jwasp-ne256-nu9.4e11/HommeTime  | awk '{print $4}'`
 t8192=`grep "prim_run" /projects/Coral_rfp_prep/preqx.8192/jwasp-ne256-nu9.4e11/HommeTime  | awk '{print $4}'`

#This multiplier is added because running with 64 processes per node (1 per core) is 2% slower than with 32 processes per node (1 per 2 cores)
#This does not appreciably affect scaling in any way, and therefore a multiplier is added to the 32 processes per node runs.
 t1024=`echo "$t1024 / 1.02 " | bc -l`
 t2048=`echo "$t2048 / 1.02 " | bc -l`
 t4096=`echo "$t4096 / 1.02 " | bc -l`
 t8192=`echo "$t8192 / 1.02 " | bc -l`

 p1024=`echo "$t1024 / 1. " | bc -l`
 p2048=`echo "$t1024 / 2. " | bc -l`
 p4096=`echo "$t1024 / 4. " | bc -l`
 p8192=`echo "$t1024 / 8. " | bc -l`

 e1024=`echo "$p1024  / $t1024 " | bc -l`
 e2048=`echo "$p2048  / $t2048 " | bc -l`
 e4096=`echo "$p4096  / $t4096 " | bc -l`
 e8192=`echo "$p4096  / $t8192 " | bc -l`

 sypd1024=`echo "( 3600. * 24. ) / ( $t1024  * 365. )" | bc -l`
 sypd2048=`echo "( 3600. * 24. ) / ( $t2048  * 365. )" | bc -l`
 sypd4096=`echo "( 3600. * 24. ) / ( $t4096  * 365. )" | bc -l`
 sypd8192=`echo "( 3600. * 24. ) / ( $t8192  * 365. )" | bc -l`

 psypd1024=`echo "( 3600. * 24. ) / ( $p1024  * 365. )" | bc -l`
 psypd2048=`echo "( 3600. * 24. ) / ( $p2048  * 365. )" | bc -l`
 psypd4096=`echo "( 3600. * 24. ) / ( $p4096  * 365. )" | bc -l`
 psypd8192=`echo "( 3600. * 24. ) / ( $p8192  * 365. )" | bc -l`

echo "Nodes Actual_Time Ideal_Time Parallel_Efficiency Actual_SYPD Ideal_SYPD" > scaling.dat
echo "1024  $t1024  $p1024  $e1024  $sypd1024  $psypd1024  " >> scaling.dat
echo "2048  $t2048  $p2048  $e2048  $sypd2048  $psypd2048  " >> scaling.dat
echo "4096  $t4096  $p4096  $e4096  $sypd4096  $psypd4096  " >> scaling.dat
echo "8192  $t8192  $p8192  $e8192  $sypd8192  $psypd8192  " >> scaling.dat

gnuplot plot.gnuplot
