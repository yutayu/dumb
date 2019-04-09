#!/bin/bash
#cores=$(nproc --all)
#zramを1coreで運用します。ついでにlz4という展開速度の速いアルゴリズムを使わせます。
#カーネル3.15以上
#For multicore systems, set maxs equal to the number of cores. If you're using old kernel (< 3.15), configure separate swap devices per core
#https://wiki.gentoo.org/wiki/Zram
#sudo　chmod +x を適用してお試しください。
#このスクリプトは75%(3/4)の物理メモリを圧縮します。調整は3/4の分数をみなおしてください。
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
