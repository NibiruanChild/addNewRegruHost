#!/bin/bash
# Скрипт проверяет совпадение IP в файле hosts с IP, которое отдает nslookup

# Красивые цветные статус-сообщения
fail_mes='[\E[31;47m\E[1m FAIL \E[0m]'
ok_mes='[\E[32;47m\E[1m  OK  \E[0m]'

for i in `cat /etc/hosts | grep "reg.ru" | grep -v "#" | awk {'print $2'} | xargs`
do
	iphosts=`cat /etc/hosts | grep "reg.ru" | grep -v "#" | grep "${i}" | awk {'print $1'} | sed "s#\ \+##g"`
	ipnslookup=`nslookup ${i} 8.8.8.8 | grep -v "#" | grep "Address:" | awk {'print $2'} | sed "s#\ \+##g"`
	if [[ "$iphosts" != "$ipnslookup" ]]; then
			echo -e "${fail_mes}   $i:\n\t\t\t hostsIP:    $iphosts \n\t\t\t nslookupIP: $ipnslookup";
		else
			echo -e "${ok_mes}   $i:\t $iphosts";	
	fi	
done


# oneline script 
# fail_mes='[\E[31;47m\E[1m FAIL \E[0m]' ; ok_mes='[\E[32;47m\E[1m  OK  \E[0m]' ; for i in `cat /etc/hosts | grep "reg.ru" | grep -v "#" | awk {'print $2'} | xargs`; do iphosts=`cat /etc/hosts | grep "reg.ru" | grep -v "#" | grep "${i}" | awk {'print $1'} | sed "s#\ \+##g"` ; ipnslookup=`nslookup ${i} 8.8.8.8 | grep -v "#" | grep "Address:" | awk {'print $2'} | sed "s#\ \+##g"`; if [[ "$iphosts" != "$ipnslookup" ]]; then echo -e "${fail_mes}   $i:\n\t\t\t hostsIP:    $iphosts \n\t\t\t nslookupIP: $ipnslookup"; else echo -e "${ok_mes}   $i:\t $iphosts"; fi; done 



