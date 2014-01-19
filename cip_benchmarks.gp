reset

fontsize = 20
set term postscript enhanced eps fontsize
set output "| ps2pdf - - | pdfcrop - cip_benchmarks.pdf"

set boxwidth 1 relative

set style fill solid 1.00 border 0
set style histogram errorbars gap 2 lw 1
set style data histogram
set xtics rotate by -45
set grid ytics
set xlabel ""
set ylabel "Execution time\n(normalized against Kaplan)"


set yrange [0:1.2]

set label ">50" at 1.65,1.25

set key at 0.01,-0.4

set datafile separator "|"
plot 'cip_benchmarks_norm.dat' \
     using 2:3:xtic(1) ti "Turtle" lc 1, \
     '' using 4:5 ti "Kaplan" lt 1 lc 2, \
     '' using 6:7 ti "Babelsberg/R" lt 1 lc 3, \
     '' using 8:9 ti "Prolog" lt 1 lc 4
