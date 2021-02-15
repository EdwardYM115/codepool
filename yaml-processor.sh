#!/bin/sh
DIALOG_CANCEL=1
DIALOG_ESC=255
while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "k8s yaml processor" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" 0 0 4 \
    "1" "Replace Image" \
	"2" "Replace Image Pull Secret" \
	"3" "Replace API Version" \
	"4" "Process Noisy Info" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      exit
      ;;
    $DIALOG_ESC)
      clear
      #echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      ;;
    1 )
      oimg=$(dialog --title "Replace Image" --inputbox "Original Image:" 0 0 3>&1 1>&2 2>&3 3>&- )
      nimg=$(dialog --title "Replace Image" --inputbox "New Image:" 0 0 3>&1 1>&2 2>&3 3>&- )
	  oimgnumb=$(grep -Rl "image: $oimg" ./k8s-yaml-dump/*|wc -l)
	  nimgnumb=$(grep -Rl "image: $nimg" ./k8s-yaml-dump/*|wc -l)
	  echo "Original Image: $oimg" > ./k8s-yaml-dump/process-image.log
	  echo "New Image: $nimg" >> ./k8s-yaml-dump/process-image.log
	  echo "Files need to be processed:" >> ./k8s-yaml-dump/process-image.log
	  grep -Rl "image: $oimg" ./k8s-yaml-dump/* >> ./k8s-yaml-dump/process-image.log
	  echo "\n" >> ./k8s-yaml-dump/process-image.log
      find ./k8s-yaml-dump/ -name \*.yaml|xargs -n 1 sed -i "s/image: $oimg/image: $nimg/g"
	  oimgnuma=$(grep -Rl "image: $oimg" ./k8s-yaml-dump/*|wc -l)
	  nimgnuma=$(grep -Rl "image: $nimg" ./k8s-yaml-dump/*|wc -l)
	  procnum=`expr $nimgnuma - $nimgnumb`
	  echo "Files Process Failed:" >> ./k8s-yaml-dump/process-image.log
	  grep -Rl "image: $oimg" ./k8s-yaml-dump/* >> ./k8s-yaml-dump/process-image.log
	  echo "\n" >> ./k8s-yaml-dump/process-image.log
	  echo "Files Process Succeed:" >> ./k8s-yaml-dump/process-image.log
	  grep -Rl "image: $nimg" ./k8s-yaml-dump/* >> ./k8s-yaml-dump/process-image.log
      dialog --title "Replace Image Complete!" --msgbox "Files:$oimgnumb Replace:$procnum Left:$oimgnuma" 0 0
	  clear
      ;;
    2 )
      oscrt=$(dialog --title "Replace Image Pull Secret" --inputbox "Original Secret:" 0 0 3>&1 1>&2 2>&3 3>&- )
      nscrt=$(dialog --title "Replace Image Pull Secret" --inputbox "New Secret:" 0 0 3>&1 1>&2 2>&3 3>&- )
	  oscrtnumb=$(grep -PRzl "imagePullSecrets:\n        - name: $oscrt" ./k8s-yaml-dump/*|wc -l)
	  nscrtnumb=$(grep -PRzl "imagePullSecrets:\n        - name: $nscrt" ./k8s-yaml-dump/*|wc -l)
	  echo "Original Secret: $oscrt" > ./k8s-yaml-dump/process-imagepullsecret.log
	  echo "New Secret: $nscrt" >> ./k8s-yaml-dump/process-imagepullsecret.log
	  echo "Files need to be processed:" >> ./k8s-yaml-dump/process-imagepullsecret.log
	  grep -PRzl "imagePullSecrets:\n        - name: $oscrt" ./k8s-yaml-dump/* >> ./k8s-yaml-dump/process-imagepullsecret.log
	  echo "\n" >> ./k8s-yaml-dump/process-imagepullsecret.log
      find ./k8s-yaml-dump/ -name \*.yaml|xargs -n 1 sed -i ":a;N;\$!ba;s/imagePullSecrets:\n        - name: $oscrt/imagePullSecrets:\n        - name: $nscrt/g"
	  oscrtnuma=$(grep -PRzl "imagePullSecrets:\n        - name: $oscrt" ./k8s-yaml-dump/*|wc -l)
	  nscrtnuma=$(grep -PRzl "imagePullSecrets:\n        - name: $nscrt" ./k8s-yaml-dump/*|wc -l)
	  procnum=`expr $nscrtnuma - $nscrtnumb`
	  echo "Files Process Failed:" >> ./k8s-yaml-dump/process-imagepullsecret.log
	  grep -PRzl "imagePullSecrets:\n        - name: $oscrt" ./k8s-yaml-dump/* >> ./k8s-yaml-dump/process-imagepullsecret.log
	  echo "\n" >> ./k8s-yaml-dump/process-imagepullsecret.log
	  echo "Files Process Succeed:" >> ./k8s-yaml-dump/process-imagepullsecret.log
	  grep -PRzl "imagePullSecrets:\n        - name: $nscrt" ./k8s-yaml-dump/* >> ./k8s-yaml-dump/process-imagepullsecret.log
      dialog --title "Replace Image Pull Secret Complete!" --msgbox "Files:$oscrtnumb Replace:$procnum Left:$oscrtnuma" 0 0
      clear
      ;;
    3 )
      find ./k8s-yaml-dump/ -name \*.yaml|xargs -n 1 sed -i 's/^- apiVersion: extensions\/v1beta1/- apiVersion: apps\/v1/g'
	  dialog --title "Replace API Version" --msgbox "    Complete!" 0 0
	  clear
	  ;;
	4 )
	  find ./k8s-yaml-dump/ -name \*.yaml|xargs -n 1 sed -i 's/^\s*clusterIP:/#clusterIP:/g'
      find ./k8s-yaml-dump/ -name \*.yaml|xargs -n 1 sed -i 's/^\s*resourceVersion:/#resourceVersion:/g'
      find ./k8s-yaml-dump/ -name \*.yaml|xargs -n 1 sed -i 's/^\s*selfLink:/#selfLink:/g'
      find ./k8s-yaml-dump/ -name \*.yaml|xargs -n 1 sed -i 's/^\s*uid:/#uid:/g'
	  dialog --title "Process Noisy Info" --msgbox "    Complete!" 0 0
	  clear
	  ;;
  esac
done