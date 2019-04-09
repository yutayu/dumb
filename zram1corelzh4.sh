#!/bin/bash
#cores=$(nproc --all)
cores=1

swapoff -a
rmmod zram
modprobe zram num_devices=$cores



 echo 'lz4' > /sys/block/zram0/comp_algorithm

totalmem=`free | grep -e "^Mem:" | awk '{print $2}'`
mem=$(( ($totalmem / $cores )* 1024* 3 / 4 ))

core=0
while [ $core -lt $cores ]; do
  echo $mem > /sys/block/zram$core/disksize

  mkswap /dev/zram$core
  swapon -p 100 /dev/zram$core
  let core=core+1
done
