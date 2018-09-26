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

#!/bin/bash

aa1=aaa
aa2=bbb
aa3=ccc

for i in `seq 1 10`; do
	x=aa$i
	echo ${!x}
done
