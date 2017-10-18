#!/bin/tcsh -f

### Point to root of trunk, branch, and where output should be stored 
set TRUNK_ROOT = ~/codes/homme
set BRANCH_ROOT = ~/codes/branch
set HOMME_REG_TEST_OUT = ~/scratch1/compare-reg-tests

### run trunk reg tests
setenv HOMME_OUT $HOMME_REG_TEST_OUT/trunk
setenv HOMME_ROOT $TRUNK_ROOT
date > $HOMME_REG_TEST_OUT/timing.barodg.trunk
cd individual_tests
./baro-dg.sh
cd ..
date >> $HOMME_REG_TEST_OUT/timing.barodg.trunk
### clean up system variables
unset HOMME_OUT
unset HOMME_ROOT

### run branch reg tests
setenv HOMME_OUT $HOMME_REG_TEST_OUT/branch
setenv HOMME_ROOT $BRANCH_ROOT
date > $HOMME_REG_TEST_OUT/timing.barodg.branch
cd individual_tests
./baro-dg.sh
cd ..
date >> $HOMME_REG_TEST_OUT/timing.barodg.branch
### clean up system variables
unset HOMME_OUT
unset HOMME_ROOT

### compare output (python script to come?)
