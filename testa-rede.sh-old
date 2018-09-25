 #!/bin/bash                                                                                                                           
nomehost1="195154"
endereht1="195.154.32.64"
arquivht1="http://195.154.32.64/10.mb"
nomehost2="62210"
endereht2="62.210.6.33"
arquivht2="http://62.210.6.33/10.mb"
nomehost3="21283"
endereht3="212.83.168.74"
arquivht3="http://212.83.168.74/10.mb"

data_inic=`date +%Y-%m-%d`
caminho=$(dirname "$0")

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
                printf $hora >> $caminho"/"$data_inic"_"$2"_wget-csv"
                printf " $valuni" >> $caminho"/"$data_inic"_"$2"_wget-csv"
                printf " $valor\n" >> $caminho"/"$data_inic"_"$2"_wget-csv"
        echo $line >> "confere_"$2
        done
}

csv-ping () {
linha=1
interv=120
numping=5
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
                        echo "$linha 8888 $hrf" >> $caminho"/"$data_inic"_"$2"_ping-csv"
                        let linha=$linha+1
                done
                let linha=$linha+1
        else
                let linha=$linha+1
        fi
        timst=$(date +%s)
        hora=`date +%T -d @$timst`
        [[ $data_inic != $(date +%Y-%m-%d) ]] && break 1
        echo "$seq $time $hora" >> $caminho"/"$data_inic"_"$2"_ping-csv"
done
}

#csv-ping $endereht1 $nomehost1
#csv-wget $arquivht1 $nomehost1
while [[ "$data_inic" == "`date +%Y-%m-%d`" ]]; do
        csv-wget $arquivht1 $nomehost1
        sleep 2
        csv-wget $arquivht2 $nomehost2
        sleep 2
        csv-ping $endereht1 $nomehost1 &
        sleep 60 # metade do interv
        csv-ping $endereht2 $nomehost2
        sleep 2

        csv-wget $arquivht2 $nomehost2
        sleep 2
        csv-wget $arquivht1 $nomehost1
        sleep 2
        csv-ping $endereht2 $nomehost2 &
        sleep 60 # metade do interv
        csv-ping $endereht1 $nomehost1
        sleep 2
done
