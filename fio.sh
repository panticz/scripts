#!/bin/bash

OUT=/tmp/fio.out

# install fio
sudo apt-get install -y fio

# clear
[ -f ${OUT} ] && rm ${OUT}

# run fio benchmark
for SIZE in 4 8 16; do
    for BS in 4 16 64; do
        for JOBS in 128 254 512; do
            for TIME in 60 120 240; do
                RESULT=$(fio --rw=readwrite --name=test --direct=1 --group_reporting --time_based --size=${SIZE}M --bs=${BS}k --numjobs=${JOBS} --runtime=${TIME} | grep iops | cut -d "=" -f4 | cut -d "," -f1)
                echo "${SIZE}M,${BS}K,${JOBS}x,${TIME}s,$(echo ${RESULT} | tr ' ', ',')" | tee -a ${OUT}
            done
        done
    done
done
