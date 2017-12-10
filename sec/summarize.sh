#!/bin/sh
echo time,i,sfc,net,vnf,pm,vm_cpu,min_cpu,vm_mem,min_mem,vm_sto,min_sto,cpu_usage,mem_usage,sto_usage,fg,traffic,latFW,latDPI,latIDS,bnd_usage,lossFW,lossDPI,lossIDS,sla,tr_stratos,thr_stratos >> summary-$1.csv
#echo time,i,net,vnf,nic_throughput,queue,resident,committed,usage,active,steal,drop,latFW,latDPI,latIDS,lossFW,lossDPI,lossIDS >> summary.csv

for i in `seq 0 29`
do
for net in '10Mbps' '50Mbps' '100Mbps'
do
for vnf in 'ids' 'dpi' 'fw'
do
for time in `seq 1 130`
do
	tr_stratos=`cat run-$1/log-stratos-$net-$i | awk '{ print $4 }' | sed 's/,//g'| sed -n ''$time' p'`
	thr_stratos=`cat run-$1/log-stratos-$net-$i | awk '{ print $2 }' | sed 's/,//g'| sed -n ''$time' p'`
	#demand=`tail -n +7 behavior-performance.csv | cut -d ',' -f 2 | sed -n ''$time' p'`
	nic_throughput=`cat run-$1/output-ifstat-$net-$vnf-$i.dat | grep -v eth0 | grep -v KB | awk '{ print $2 }' |sed -n ''$time' p'`
	queue=`cat run-$1/output-tc-$net-$vnf-$i.dat | awk '{ print $2 }' | sed 's/b//g'| sed 's/K/000/g' | sed -n ''$time' p'`
	resident=`tail -n +4 run-$1/output-sarMem-$net-$vnf-$i.dat | awk '{ print $5 }'| sed -n ''$time' p'`
	committed=`tail -n +4 run-$1/output-sarMem-$net-$vnf-$i.dat | awk '{ print $9 }'| sed -n ''$time' p'`
	mem=`tail -n +4 run-$1/output-sarMem-$net-$vnf-$i.dat | awk '{ print $5 }'| sed -n ''$time' p'`

	#cache=`tail -n +3 run-$1/output-cache-$net-$vnf-$i.dat | awk '{ print $4 }'| sed 's/%//g' |sed -n ''$time' p'`
	usage=`tail -n +4 run-$1/output-mpstat-$net-$vnf-$i.dat | awk '{ print 100-$13 }'| sed -n ''$time' p'`
	iops=`cat run-$1/output-iostat-$net-$vnf-$i.dat | grep sda | awk '{print $2}' | sed -n ''$time' p'`
	#active=`cat run-$1/output-active-$net-$vnf-$i.dat | sed -n ''$time' p'`
	steal=`tail -n +4 run-$1/output-mpstat-$net-$vnf-$i.dat | awk '{ print $10 }'| sed -n ''$time' p'`

	latFW=`cat run-$1/output-pingFW-$net-$vnf-$i.dat | grep rtt | awk '{ print $4 }' | cut -d / -f 1 | sed -n ''$time' p'`
	latDPI=`cat run-$1/output-pingDPI-$net-$vnf-$i.dat | grep rtt | awk '{ print $4 }' | cut -d / -f 1 | sed -n ''$time' p'`
	latIDS=`cat run-$1/output-pingIDS-$net-$vnf-$i.dat | grep rtt | awk '{ print $4 }' | cut -d / -f 1 | sed -n ''$time' p'`

	lossFW=`cat run-$1/output-pingFW-$net-$vnf-$i.dat | grep packets | awk '{ print $6 }' | sed 's/%//g' | sed -n ''$time' p'`
	lossDPI=`cat run-$1/output-pingDPI-$net-$vnf-$i.dat | grep packets | awk '{ print $6 }' | sed 's/%//g' | sed -n ''$time' p'`
	lossIDS=`cat run-$1/output-pingIDS-$net-$vnf-$i.dat | grep packets | awk '{ print $6 }' | sed 's/%//g' | sed -n ''$time' p'`

	bnd=`echo $net | sed -e 's/'Mbps'//g'`
	bnd_usage=`echo "scale = 10; $nic_throughput / ($bnd * 1000)" | bc`
	echo $time,$i,1,$net,$vnf,1,100,100,100,100,100,100,$usage,$mem,$iops,1,$nic_throughput,$latFW,$latDPI,$latIDS,$bnd_usage,$lossFW,$lossDPI,$lossIDS,20,$tr_stratos,$thr_stratos >> summary-$1.csv
done
done
done
done
echo 'END ALL'
