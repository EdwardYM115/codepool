#!/bin/bash
mkdir ./k8s-yaml-dump
nsnum=$(cat ./ns.out|wc -l)
nsseq=1
workloadnum=$(cat ./workload.out|wc -l)
(
for namespace in `cat ./ns.out`;
do

echo "---------------Dumping namespace $namespace yaml---------------" > ./k8s-yaml-dump/dump.log
mkdir ./k8s-yaml-dump/$namespace
kubectl get namespace $namespace -o yaml>./k8s-yaml-dump/$namespace/$namespace-namespace.yaml
workloadseq=1
for workloadkind in `cat ./workload.out`;
do
echo "Dumping $workloadkind yaml" >> ./k8s-yaml-dump/dump.log
mkdir ./k8s-yaml-dump/$namespace/$workloadkind

for workload in `kubectl get $workloadkind -n $namespace 2>/dev/null|sed -n '2,$p'|awk '{print $1}'`
{
kubectl get $workloadkind $workload -n $namespace -o yaml>./k8s-yaml-dump/$namespace/$workloadkind/$namespace-$workloadkind-$workload.yaml
}

tmp=$(echo "scale=2;$workloadseq/$workloadnum"|bc)
tmp=$(echo "scale=2;$tmp*100"|bc)
per=$(echo "$tmp*100" | awk '{print int($0)}')
echo "$workloadkind yaml dumped" >> ./k8s-yaml-dump/dump.log
echo "XXX"
echo "Dumping namespace $nsseq/$nsnum $namespace $workloadkind yaml"
echo "XXX"
echo $per

workloadseq=`expr $workloadseq + 1`
done

nsseq=`expr $nsseq + 1`
done
) | dialog --title "Dumping..." --gauge "Starting to dump yaml" 6 70 0