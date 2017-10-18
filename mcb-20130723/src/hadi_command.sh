#!/bin/bash
time mpirun -n 16 ./MCBenchmark.exe --nMpiTasksX=8 --nMpiTasksY=2 --numParticles=100000 --weakScaling --numCycles
