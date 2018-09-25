# testa-rede
Testa a rede com ping e wget

#!/bin/bash
aa1="dfg"
aa2="94dfg"
aa3=""
aa4=""

n=1
v=aa$n

while [ ${!v} ]; do
        echo $v " -> " ${!v}
        let "n+=1"
        v=aa$n
done
