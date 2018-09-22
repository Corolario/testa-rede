#!/bin/bash
caminho=$(dirname "$0")
host1="195154"
host2="62210"
host3="21283"
hj_titulo=`date +%d/%b/%Y`
hj_arquivo=`date +%Y-%m-%d`
csv1=$caminho"/"$hj_arquivo"_"$host1"_wget-csv"
csv2=$caminho"/"$hj_arquivo"_"$host2"_wget-csv"
csv3=$caminho"/"$hj_arquivo"_"$host3"_wget-csv"
fimrange=$(date +%H:%M)
png1=$hj_arquivo"_wget.png"
gnuplot <<EOF
set title "$hj_titulo - Velociade de download ao longo do dia (Origem: São Paulo - Speedy Fibra 50Mb)"
set xlabel "Horario"
set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M"
set xrange ["00:00":"$fimrange"]
#set xtics "01:00"
set grid
set ylabel "Velocidade ( KB/s )"
#set log y
set yrange [100:3000]
set ytics 200
set terminal pngcairo size 1300,580
set output "$png1"
set multiplot
plot "$csv1" u 1:4 with line title "$host1"
replot "$csv2" u 1:4 with line title "$host2"
#replot "$csv3" u 1:4 with line title "$host3"
EOF
