dialog --separate-output --checklist "Choose Workload to Dump" 20 50 10 \
clusterrole workload on \
clusterrolebinding workload on \
configmap workload on \
daemonset workload on \
deployment workload on \
ingress workload on \
pv workload on \
pvc workload on \
role workload on \
rolebinding workload on  \
secret workload on \
service workload on \
serviceaccount workload on \
statefulset workload on \
storageclass workload on \
2>./workload.out