#!/bin/bash
time mpirun -np 16 ./amg2013 -pooldist 1 -r 1 1 1 -P 2 1 1 -solver 1
