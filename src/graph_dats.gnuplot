set title "Memory Usage"

set xlabel "Time"
set ylabel "RSS"

set xdata time
set timefmt "%Y%m%d_%H%M%S"

set grid
set autoscale
set terminal png size 6000,3000
set output "mem_usage.png"

get_pid(file) = system("basename " . file . " .dat")

plot for [ idx = 1:words(ARG1) ] \
    word(ARG1, idx) \
    using 1:2 with lines \
    title get_pid(word(ARG1, idx)) at end
    
