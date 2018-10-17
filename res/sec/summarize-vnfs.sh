#!/bin/sh
#echo time,i,net,vnf,pm,fgs,min_cpu,min_mem,min_sto,vm_cpu,vm_mem,vm_sto,cpu_usage,mem_usage,sto_usage >> summary-vnfs-$1.csv

for i in `seq 0 10`
do
for net in '10Mbps' '50Mbps' '100Mbps'
do
for vnf in 'ids' 'dpi' 'fw'
do
for time in `seq 1 120`
do
	mem=`tail -n +4 run-$1/output-sarMem-$net-$vnf-$i.dat | awk '{ print $5 }'| sed -n ''$time' p'`
	mem=`echo "scale = 10; $mem / 8" | bc`
	usage=`tail -n +4 run-$1/output-mpstat-$net-$vnf-$i.dat | awk '{ print 100-$13 }'| sed -n ''$time' p'`
	usage=`echo "scale = 10; $usage / 8" | bc`
	iops=`cat run-$1/output-iostat-$net-$vnf-$i.dat | grep sda | awk '{print $2}' | sed -n ''$time' p'`
	iops=`echo "scale = 10; $iops / 150" | bc`

	echo $time,$i,$net,$vnf,1,1,100,100,100,100,100,100,$usage,$mem,$iops >> summary-vnfs-$1.csv
done
done
done
done
echo 'END ALL'
