#!/bin/bash

###########
# Author: Lokesh Singh 
# Date: 10/02/2026
###########

file=$1
reachable=0
unreachable=0
port=0

check_host(){

	echo "Checking: $domain"

	ncat -vz -w5 "$1" 80 &> /dev/null
	if [[ $? -eq 0 ]]
	then
		echo "Reachable: YES"
		echo "PORT 80: OPEN"
		((reachable++))
		((port++))
	else
		echo "Reachable: NO"
		echo "PORT 80: SKIPPED"
		((unreachable++))
	fi
	echo "----------------"
}

while read -r domain  
do
	check_host "$domain"
done < "$file"

echo -e "\n==== SUMMARY ===="
echo "Reachable: $reachable 
Unreachable: $unreachable  
Port Open: $port
"
