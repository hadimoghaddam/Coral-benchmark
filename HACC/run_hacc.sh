#!/bin/bash
ln -s ./src/cpu/linux-generic/hacc_tpm .
mpirun -np 16 ./hacc_tpm indat cmbM000.tf m000 INIT ALL_TO_ALL -w -R -N 16 -t 4x2x2
