#!/bin/bash

# Lukovkin Petr
# p.lukovkin@reg.ru
# date: 2012-01-16
#
# Script for addition new hosting server:
# * ip and aliases to /etc/hosts 
# * ssl key to server (ssh whithout password)
# * .bashrc

script_name=`basename $0`
script_path=`dirname $0`

if [[ $# < 1 ]]; then
	echo -e "$fail_mes $script_name: Missing operand."
    echo "Usage:   $script_name newhost1 [newhost2[..]]"
    echo "Example: $script_name server28.hosting.reg.ru ovzhost10.vps.reg.ru"    
    exit
fi

if ! [[ -e ~/.ssh/id_rsa.pub ]]; then
  echo "~/.ssh/id_rsa.pub not found, please execute \"ssh-keygen -t rsa\""
  exit
fi


while [ "$1" ]
do
    echo "> $1"
    host_name_short=`echo $1 | awk -F. '{print $1}'` #serverXX splXX scpXX ...
    host_name=
    host_ip=
    case "$1" in       
    server[0-9]*)
      host_name=${host_name_short}.hosting.reg.ru      
      ;;

    sbx*)
      host_name=${host_name_short}.hosting.reg.ru
      ;;

    scp*)
      host_name=${host_name_short}.hosting.reg.ru
      ;;

    spl*)
      host_name=${host_name_short}.hosting.reg.ru
      ;;

    sda*)
      host_name=${host_name_short}.hosting.reg.ru
      ;;

    ovzhost[0-9]*)       
      host_name=${host_name_short}.vps.reg.ru
      ;;
    esac

    host_ip=`dig +short ${host_name}`
    if [[ -z ${host_ip} ]]; then
      echo "Can't resolve to IP"    
    fi

    echo -e "----> Add to /etc/hosts "

    # May be IP already exist in /etc/hosts
    if [[ -z "`sed 's#^[ \t]##' /etc/hosts | awk '{print $1}' | grep "^${host_ip}$"`" ]]; then
      case "${host_name}" in
      server*)
	# add alias "s00" for "server00"
	echo "${host_ip}    ${host_name}    ${host_name_short}    s${host_name_short:6:8}"   >> /etc/hosts
	;;
      ovzhost*)
	echo "${host_ip}    ${host_name}    ${host_name_short}    ovz${host_name_short:7:9}" >> /etc/hosts
	;;
      *)
	echo "${host_ip}    ${host_name}    ${host_name_short}"                              >> /etc/hosts
	;;
      esac
    fi

    
    echo -e "----> Add ssl key "    
    ssh-copy-id -i ~/.ssh/id_rsa ${host_name} | grep -v "^$"   | grep -v "Now try logging" | grep -v "to make sure we haven't added extra keys that you weren't expecting" | grep -v "~/.ssh/authorized_keys"


    echo -e "----> Copy .bashrc "    
    scp -q ${script_path}/bashrc ${host_name}:~/.bashrc    

    echo
    shift
done
