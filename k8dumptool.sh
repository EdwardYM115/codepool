#!/bin/bash
DIALOG_CANCEL=1
DIALOG_ESC=255
while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "K8S Dump Tool v1.0 -- Powered By Edward" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" 0 0 4 \
    "1" "Select Namespaces & Workloads" \
	"2" "Dump Yamls" \
    "3" "Dump Yamls Seperated" \
	"4" "Yaml File Processor" \
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
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      ;;
    1 )
      sh ./ns-select.sh
	  sh ./workload-select.sh
      ;;
    2 )
      if [ ! -s ./ns.out ];
      then
      kubectl get ns|sed -n '2,$p'|awk '{print $1}' > ./ns.out
      fi
	  
      if [ ! -s ./workload.out ];
      then
      cp workload.example workload.out
      fi
	  
      if [ -d k8s-yaml-dump ];
      then
      dialog --yesno "Yaml file directory existed. Overwrite it?" 5 50 2>&1
      if [ $? -eq 0 ];
      then
      rm -rf k8s-yaml-dump
	  
      sh ./gui-yaml-dump.sh
      rm -f ./ns.out
      rm -f ./workload.out
	  
      fi
      else
      sh ./gui-yaml-dump.sh
      rm -f ./ns.out
      rm -f ./workload.out
      fi
	  
	  
      ;;
    3 )
	  if [ ! -s ./ns.out ];
	  then
	  kubectl get ns|sed -n '2,$p'|awk '{print $1}' > ./ns.out
	  fi
	  
	  if [ ! -s ./workload.out ];
	  then
	  cp workload.example workload.out
	  fi
	  
	  if [ -d k8s-yaml-dump ];
	  then
	  dialog --yesno "Yaml file directory existed. Overwrite it?" 5 50 2>&1
	  if [ $? -eq 0 ];
	  then
	  rm -rf k8s-yaml-dump
	  
	  sh ./gui-yaml-dump-seperate.sh
          rm -f ./ns.out
	  rm -f ./workload.out
	  
	  fi
	  else
	  sh ./gui-yaml-dump-seperate.sh
          rm -f ./ns.out
	  rm -f ./workload.out
	  fi
	  
      ;;
     4 )
	  sh yaml-processor.sh
      ;;
  esac
done
