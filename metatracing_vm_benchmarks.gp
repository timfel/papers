reset

fontsize = 20
set term postscript enhanced eps fontsize
set output "| ps2pdf - - | pdfcrop - metatracing_vms_benchmarks.pdf"

set boxwidth 1 relative

set style fill solid 1.00 border 0
set style histogram errorbars gap 2 lw 1
set style data histogram
set xtics rotate by -45
set ytics 0,.2,2.5
set grid ytics
set xlabel ""
set ylabel "Execution time\n(normalized against unmodified VM)"
set yrange [0:2.5]

set key at 0.01,-0.4

set label ">25" at 0.15,2.35
set label ">3.9" at 1.15,2.35
set label ">33" at 2.15,2.35
set label ">10" at 3.15,2.35

set datafile separator "|"
plot 'metatracing_vm_benchmarks_normalized.dat' using 4:5:xtic(1) ti "Topaz" linecolor rgb "#FF0000", \
     '' using 6:7 ti "JRuby" lt 1 lc rgb "#00FF00", \
     '' using 8:9 ti "" lc rgb "#ffffff", \
     '' using 2:3 ti "Babelsberg/R" lt 1 lc rgb "#0000FF"
