#!/bin/bash
caminho=$(dirname "$0")
host1="195154"
host2="62210"
host3="21283"
hj_titulo=`date +%d/%b/%Y`
hj_arquivo=`date +%Y-%m-%d`
csv1=$caminho"/"$hj_arquivo"_"$host1"_ping-csv"
csv2=$caminho"/"$hj_arquivo"_"$host2"_ping-csv"
csv3=$caminho"/"$hj_arquivo"_"$host3"_ping-csv"
png1=$hj_arquivo"_ping.png"
fimrange=$(date +%H:%M)
gnuplot <<EOF
set title "$hj_titulo - Ping ao longo do dia (Origem: São Paulo - Speedy Fibra 50Mb)"
set xlabel "Horario"
set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M"
set xrange ["00:00":"$fimrange"]
set grid
set ylabel "Tempo (ms)"
set yrange [200:500]
set ytics 20
set terminal pngcairo size 1580,580
set output "$png1"
set multiplot
plot "$csv1" u 3:2 with line title "$host1"
replot "$csv2" u 3:2 with line title "$host2"
#replot "$csv3" u 3:2 with line title "$host3"
EOF
