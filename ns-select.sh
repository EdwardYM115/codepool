i=0
cmd=""
for ns in $(kubectl get ns|sed -n '2,$p'|awk '{print $1}')
do
str[$i]=$ns" ns on "
echo ${str[$i]}
cmd=$cmd${str[$i]}
i=`expr $i + 1`
done
echo $cmd
dialog --separate-output --checklist "Choose Namespace To Dump" 20 50 10 $cmd 2>./ns.out