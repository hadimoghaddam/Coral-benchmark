set terminal postscript enhanced color font 'Arial,20'
set output 'scaling_camse_mira_runtime.eps'
set logscale xy
set title 'CAM-SE Dynamical Core Scaling at ne256 on Mira'
set xrange [900:5000]
set xlabel 'Number of Nodes'
set ylabel 'Runtime in seconds'
set style line 1 lt 1 lw 3 lc rgb 'blue'
set style line 2 lt 1 lw 3 lc rgb 'red'
plot './scaling.dat' u 1:2 w lp t 'Actual' ls 1, '' u 1:3 w lp t 'Ideal' ls 2


set terminal postscript enhanced color font 'Arial,20'
set output 'scaling_camse_mira_SYPD.eps'
set logscale xy
set title 'CAM-SE Dynamical Core Scaling at ne256 on Mira'
set xrange [900:5000]
set xlabel 'Number of Nodes'
set ylabel 'Simulated Years Per wallclock Day (SYPD)'
set style line 1 lt 1 lw 3 lc rgb 'blue'
set style line 2 lt 1 lw 3 lc rgb 'red'
plot './scaling.dat' u 1:5 w lp t 'Actual' ls 1, '' u 1:6 w lp t 'Ideal' ls 2


set output 'scaling_camse_mira_PE.eps'
unset logscale xy
set title 'CAM-SE Dynamical Core Scaling at ne256 on Mira'
set xrange [900:5000]
set xlabel 'Number of Nodes'
set ylabel 'Parallel Efficiency'
set style line 1 lt 1 lw 3 lc rgb 'blue'
set style line 2 lt 1 lw 3 lc rgb 'red'
plot './scaling.dat' u 1:4 w lp t 'Actual' ls 1
