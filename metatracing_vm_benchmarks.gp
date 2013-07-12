reset
fontsize = 12
set term postscript enhanced eps fontsize
set output "| ps2pdf - - | pdfcrop - metatracing_vms_benchmarks.pdf"
set style fill solid 1.00 border 0
set style histogram errorbars gap 2 lw 1
set style data histogram
set xtics rotate by -45
set grid ytics
set xlabel "Benchmarks"
set ylabel "Execution time normalized against unmodified VM"
set yrange [0:*]
set datafile separator ","
plot 'metatracing_vm_benchmarks_normalized.dat' using 2:3:xtic(1) ti "Babelsberg/R" linecolor rgb "#FF0000", \
     '' using 4:5 ti "Topaz" lt 1 lc rgb "#00FF00"
