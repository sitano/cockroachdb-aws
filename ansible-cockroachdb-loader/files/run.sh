#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

N=3
RECORD=1000000000

read -r -a NODES <<< $(cat /nodes_internal)
NODES_LEN=${#NODES[@]}

echo "round robin through nodes: ${NODES[@]}"

for i in $(seq 0 $(($N-1)))
do 
  NODE=${NODES[$(($i%$NODES_LEN))]}
  echo "$NODE"
  screen -L -S "ycsb-run-$i" -d -m /opt/ycsb/bin/ycsb run postgrenosql \
    -threads 64 \
    -P /opt/ycsb/workloads/workloada \
    -p measurementtype=hdrhistogram \
    -p insertorder=ordered -p zeropadding=12 \
    -p recordcount=$RECORD -s \
    -p postgrenosql.url=jdbc:postgresql://$NODE:26257/ycsb \
    -p postgrenosql.user=root -p postgrenosql.passwd= \
    -p postgrenosql.autocommit=true \
    -p fieldcount=10 -p fieldlength=128
done

