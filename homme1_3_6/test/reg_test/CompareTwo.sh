#!/bin/tcsh -f
#SBATCH -N 2
#SBATCH --account=FY127788 
#SBATCH --time=0:60:00

### Point to root of trunk, branch, and where output should be stored 
set TRUNK_ROOT = ~/codes/homme_trunk
set BRANCH_ROOT = ~/codes/homme
set HOMME_REG_TEST_OUT = ~/scratch1/compare-reg-tests

### run trunk reg tests
setenv HOMME_OUT $HOMME_REG_TEST_OUT/homme1_2_1
setenv HOMME_ROOT $TRUNK_ROOT
set TRUNK_OUT = $HOMME_OUT

#./alltests.sh -t timing.out.trunk # Run all tests, output timing info to timing.out.trunk
### clean up system variables
unset HOMME_OUT
unset HOMME_ROOT

### run branch reg tests
setenv HOMME_OUT $HOMME_REG_TEST_OUT/branch
setenv HOMME_ROOT $BRANCH_ROOT
set BRANCH_OUT = $HOMME_OUT

#./alltests.sh -t timing.out.branch # Run all tests, output timing info to timing.out.branch
### clean up system variables
unset HOMME_OUT
unset HOMME_ROOT

### move timing results to $HOMME_REG_TEST_OUT
mv -f timing.out.trunk $HOMME_REG_TEST_OUT
mv -f timing.out.branch $HOMME_REG_TEST_OUT

### compare output (python script to come?)
foreach name ( \
./sweqx/swtc1/sweqx.out \
./sweqx/swtc5/sweqx.out \
./sweqx/swtc6/sweqx.out \
./swdgx/swtc1-dg/swdgx.out \
./swdgx/swtc2-dg/swdgx.out \
./swdgx/swtc5-dg/swdgx.out \
./preqx/baro1a/preqx.out \
./preqx/baro1b/preqx.out \
./preqx/baro2a/preqx.out \
./preqx/baro2b/preqx.out \
./preqx/baro2c/preqx.out \
)
  echo ==========================================================
  echo running diff on 
  echo $name
  echo ==========================================================
   diff   $TRUNK_OUT/$name $BRANCH_OUT/$name 
end
