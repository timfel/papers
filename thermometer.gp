reset
fontsize = 12
set term postscript enhanced eps fontsize
set output "| ps2pdf - - | pdfcrop - thermometer.pdf"
set style fill solid 1.00 border 0
set style histogram errorbars gap 2 lw 1
set style data histogram
set xtics rotate by -45
set grid ytics
set xlabel "Iterations"
set ylabel "Execution time normalized against imperative code at 10,000 iterations"
set yrange [0:150]
set datafile separator ","
plot 'thermometer_normalized.dat' using 2:3:xtic(1) ti "Imperative" linecolor rgb "#FF0000", \
     '' using 4:5 ti "Constraint Loop" lt 1 lc rgb "#00FF00", \
     '' using 6:7 ti "Edit Constraints" lt 1 lc rgb "#0000FF"
