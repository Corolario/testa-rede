#!/bin/bash                                                                                                                           
nomehost1="195.154.32.64"               # Nome do host 1 (para exibição e nome de arquivos csv)
endereht1="195.154.32.64"               # Endereço do host 1 (para o ping)
arquivht1="http://195.154.32.64/10.mb"  # Caminho do arquivo 1 (para o wget)

nomehost2="62.210.6.33"
endereht2="62.210.6.33"                 # Idem p/ o host 2
arquivht2="http://62.210.6.33/10.mb"

nomehost3="212.83.168.74"
endereht3="212.83.168.74"               # Idem p/ o host 3
arquivht3="http://212.83.168.74/10.mb"

interv=120	# Intervalo entre pings
numping=10	# Número de pings

# caminho=$(dirname "$0")
caminho=$(pwd)
data_inic=`date +%Y-%m-%d`

csv-wget () {
wget -O /dev/null $1 2>&1 | while read line; do
        [[ ! "$line" =~ "B/s" ]] && continue
        hora=$(echo $line | cut -d" " -f 2)
        valuni=$(echo $line | grep -o '[0-9]*[.|,]\?[0-9]\+ [KM]B/s')
        valor=$(echo $valuni | cut -d" " -f 1 | tr , .)
        unidd=$(echo $valuni | cut -d" " -f 2)
        if [ $unidd = 'MB/s' ]; then
                valor=$(echo $valor*1000 |bc)
        fi
        [[ $data_inic != $(date +%Y-%m-%d) ]] && break 1
        printf $hora >> $caminho"/"$data_inic"_"$2"_wget.csv"
        printf " $valuni" >> $caminho"/"$data_inic"_"$2"_wget.csv"
        printf " $valor\n" >> $caminho"/"$data_inic"_"$2"_wget.csv"
echo $line >> "confere_"$2
done
}

csv-ping () {
# interv=	# Configurado no início do arquivo
# numping=	# Configurado no início do arquivo
linha=1
ping $1 "-i $interv" "-c $numping" | while read line; do
        [[ ! "$line" =~ "bytes from" ]] && continue # pula linhas inuteis
        seq=${line##*icmp_seq=} #pega o numero da sequencia
        seq=${seq%% *}
        time=${line##*time=} #pega a hora
        time=${time%% *}
        if [ $linha -lt $seq ]; then
                let inicio_seq=$linha
                let final_seq=$((seq-1))
                [[ $linha -eq 1 ]] &&  let timst=$(date +%s)-2*$interv
                for num in `seq $inicio_seq $final_seq`; do
                        let timst=$timst+$interv
                        hrf=`date +%T -d @$timst`
                        [[ $data_inic != $(date +%Y-%m-%d) ]] && break 1
                        echo "$linha 8888 $hrf" >> $caminho"/"$data_inic"_"$2"_ping.csv"
                        let linha=$linha+1
                done
                let linha=$linha+1
        else
                let linha=$linha+1
        fi
        timst=$(date +%s)
        hora=`date +%T -d @$timst`
        [[ $data_inic != $(date +%Y-%m-%d) ]] && break 1
        echo "$seq $time $hora" >> $caminho"/"$data_inic"_"$2"_ping.csv"
done
}

wgetcsv1=$caminho"/"$data_inic"_"$nomehost1"_wget.csv"
wgetcsv2=$caminho"/"$data_inic"_"$nomehost2"_wget.csv"
wgetcsv3=$caminho"/"$data_inic"_"$nomehost3"_wget.csv"
wgetpng=$caminho"/"$data_inic"_wget.png"
plot-wget (){
iniciorange=$(head -c 3 $wgetcsv1)00
fimrange=$(date +%H:%M)
gnuplot <<EOF
        set title "$data_inic - Velociade de download ao longo do dia (Origem: São Paulo - Speedy Fibra 50Mb)"
        set xlabel "Horario"
        set xdata time
        set timefmt "%H:%M:%S"
        set format x "%H:%M"
        set xrange ["$iniciorange":"$fimrange"]
        #set xtics "01:00"
        set grid
        set ylabel "Velocidade ( KB/s )"
        #set log y
        set yrange [50:2200]
        set ytics 100
        set terminal pngcairo size 1300,580
        set output "$wgetpng"
        set multiplot
        plot "$wgetcsv1" u 1:4 with points title "$nomehost1", "$wgetcsv2" u 1:4 with points title "$nomehost2"
        # "$wgetcsv3" u 1:4 with line title "$nomehost3"
EOF
}

pingcsv1=$caminho"/"$data_inic"_"$nomehost1"_ping.csv"
pingcsv2=$caminho"/"$data_inic"_"$nomehost2"_ping.csv"
pingcsv3=$caminho"/"$data_inic"_"$nomehost3"_ping.csv"
pingpng=$caminho"/"$data_inic"_ping.png"
plot-ping () {
iniciorange=$(head -n 1 $pingcsv1 | cut -d" " -f 3 | head -c 3)00
fimrange=$(date +%H:%M)
gnuplot <<EOF
        set title "$hj_titulo - Ping ao longo do dia (Origem: São Paulo - Speedy Fibra 50Mb)"
        set xlabel "Horario"
        set xdata time
        set timefmt "%H:%M:%S"
        set format x "%H:%M"
        set xrange ["$iniciorange":"$fimrange"]
        set grid
        set ylabel "Tempo (ms)"
        set yrange [200:500]
        set ytics 20
        set terminal pngcairo size 1580,580
        set output "$pingpng"
        set multiplot
        plot "$pingcsv1" u 3:2 with points title "$nomehost1", "$pingcsv2" u 3:2 with points title "$nomehost2"
        # "$pingcsv3" u 3:2 with line title "$nomehost3"
EOF
}

# csv-wget $arquivht1 $nomehost1
# sleep 1
# csv-wget $arquivht2 $nomehost2
# sleep 1

# csv-ping $endereht1 $nomehost1 &
# sleep 1
# csv-ping $endereht2 $nomehost2
# sleep 1

# csv-wget $arquivht2 $nomehost2
# sleep 1
# csv-wget $arquivht1 $nomehost1

# plot-wget
# plot-ping

while [[ "$data_inic" == "`date +%Y-%m-%d`" ]]; do
        csv-wget $arquivht1 $nomehost1
        sleep 1
        csv-wget $arquivht2 $nomehost2
        sleep 1
        csv-ping $endereht1 $nomehost1 &
        sleep 60 # metade de interv
        csv-ping $endereht2 $nomehost2
        sleep 1

        csv-wget $arquivht2 $nomehost2
        sleep 1
        csv-wget $arquivht1 $nomehost1
        sleep 1
        csv-ping $endereht2 $nomehost2 &
        sleep 60 # metade de interv
        csv-ping $endereht1 $nomehost1
        sleep 1

        plot-wget
		plot-ping
done
