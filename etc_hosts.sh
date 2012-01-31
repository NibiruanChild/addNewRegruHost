#!/bin/bash

# Lukovkin Petr
# p.lukovkin@reg.ru
# date: 2011-09-20
#
# Script for addition new hosting server:
# * ip and aliases to /etc/hosts 
# * ssl key to server (ssh whithout password)
# * .bashrc

error_mes='[\E[31;47m Error \E[0m]'
ok_mes='[\E[32;47m\E[1m OK \E[0m]'
fail_mes='[\E[31;47m\E[1m FAIL \E[0m]'

check_status()
{
if [ $# -gt 1 ] && [ $2 == 'strict' ]; then
	mode='strict'
else
	mode='loose'
fi

if [ $1 -eq 0 ]; then
	echo -e "$ok_mes"
	else
		if [ $mode == 'strict' ]; then
		echo -e "$fail_mes"
		exit 1
		else
		echo -e "$error_mes"
		fi
fi
}

#              #
# START SCRIPT #
#              #

script_name=`basename $0`
script_path=`dirname $0`

if [[ $# < 1 ]]; then
	echo -e "$fail_mes $script_name: Missing operand."
    echo "Usage:   $script_name newhost1 newhost2 ..."
	exit 0
fi

for i
do

newhost_name=$i
newhost_shortname=`echo -n ${newhost_name} | awk -F "." {'print $1'}` # short name aka without "hosting.reg.ru" and another

############################
# add host to /etc/hosts
############################

#echo -n "Addition ip and aliases to /etc/hosts: "
newhost_ip=`host ${newhost_name} | grep "has address" |awk {'print $4'}`

# Is $newhost_ip containing IP?
if ! [[ ${newhost_ip} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
  echo "Can't resolve to IP"
  exit 1
fi

# May be IP already exist in /etc/hosts
if [[ "`cat /etc/hosts | grep ${newhost_ip} | wc -l`" -gt "0" ]]; then
  echo "Already exist"
  # - ${ok_mes}"
else
  case "${newhost_shortname}" in
  server*)
    # add alias "s00" for "server00"
    echo "${newhost_ip}    ${newhost_name}    ${newhost_shortname}    s${newhost_shortname:6:8}" >> /etc/hosts
    ;;
  backup*)
    # add alias "b00" for "backup00"
    echo "${newhost_ip}    ${newhost_name}    ${newhost_shortname}    b${newhost_shortname:6:8}" >> /etc/hosts
    ;;
  ovzhost*)
    # add alias "b00" for "backup00"
    echo "${newhost_ip}    ${newhost_name}    ${newhost_shortname}    ovz${newhost_shortname:7:9}" >> /etc/hosts
    ;; 
  xenhost*)
    # add alias "b00" for "backup00"
    echo "${newhost_ip}    ${newhost_name}    ${newhost_shortname}    xen${newhost_shortname:7:9}" >> /etc/hosts
    ;;
  *)
    echo "${newhost_ip}    ${newhost_name}    ${newhost_shortname}"                              >> /etc/hosts
    ;;
  esac
  echo "OK"
fi

done
