#!/bin/sh

for i in `seq 0 29`
do
for net in '10Mbps' '50Mbps' '100Mbps'
do
for time in `seq 1 120`
do
	tr_stratos=`cat run-$1/log-stratos-$net-$i | awk '{ print $4 }' | sed 's/,//g'| sed -n ''$time' p'`
	thr_stratos=`cat run-$1/log-stratos-$net-$i | awk '{ print $2 }' | sed 's/,//g'| sed -n ''$time' p'`

	if [ -z $tr_stratos ]
	then
			tr_stratos=`echo 0`
	fi

	if [ -z $thr_stratos ]
	then
			thr_stratos=`echo 0`
	fi

	echo $time,$i,$net,1,2,$tr_stratos,$thr_stratos >> summary-fgs-$1.csv

for vnf in 'ids' 'fw' 'dpi'
do
	nic_throughput=`cat run-$1/output-ifstat-$net-$vnf-$i.dat | grep -v eth0 | grep -v KB | awk '{ print $2 }' | sed -n ''$time' p'`
	bnd=`echo $net | sed -e 's/'Mbps'//g'`
	bnd_usage=`echo "scale = 10; $nic_throughput / ($bnd * 1024)" | bc`

	if [ $1 = 02 ]
	then
			if [ $vnf = "fw" ]
			then
					next_vnf="ids"
			fi

			if [ $vnf = "ids" ]
			then
					next_vnf="dpi"
			fi

			if [ $vnf = "dpi" ]
			then
			    break
			fi
	fi

	if [ $1 = 03 ]
	then
			if [ $vnf = "ids" ]
			then
					next_vnf="fw"
			fi

			if [ $vnf = "fw" ]
			then
					next_vnf="dpi"
			fi

			if [ $vnf = "dpi" ]
			then
			    break
			fi
	fi

	next_upper=$(echo "$next_vnf" | tr '[:lower:]' '[:upper:]')
	lat=`cat run-$1/output-ping$next_upper-$net-$vnf-$i.dat | grep rtt | awk '{ print $4 }' | cut -d / -f 1 | sed -n ''$time' p'`
	loss=`cat run-$1/output-ping$next_upper-$net-$vnf-$i.dat | grep packets | awk '{ print $6 }' | sed 's/%//g' | sed -n ''$time' p'`

	echo $vnf,$next_vnf,$nic_throughput,$lat,$bnd_usage,$loss,50 >> summary-fgs-$1.csv
done
done
done
done
echo 'END ALL'
