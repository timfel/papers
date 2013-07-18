reset
fontsize = 24
set term postscript enhanced eps fontsize
set output "| ps2pdf - - | pdfcrop - metatracing_vms_benchmarks.pdf"
set style fill solid 1.00 border 0
set style histogram errorbars gap 2 lw 1
set style data histogram
set xtics rotate by -45
set grid ytics
set xlabel ""
set ylabel "Execution time\n(normalized against unmodified VM)"
set yrange [0:4]

set key at 0.01,-0.5

set label ">25" at 0.23,3.85
set label ">33" at 2.23,3.85
set label ">10" at 3.23,3.85

set datafile separator "|"
plot 'metatracing_vm_benchmarks_normalized.dat' using 4:5:xtic(1) ti "Topaz" linecolor rgb "#FF0000", \
     '' using 6:7 ti "JRuby" lt 1 lc rgb "#00FF00", \
     '' using 2:3 ti "Babelsberg/R" lt 1 lc rgb "#0000FF"
