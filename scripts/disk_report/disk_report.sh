#!/bin/bash

file=$1
size=$2

if [[ -z $file || -z $size ]]; then
    echo "Usage: ./disk_report.sh [File_name] [Size]"
    exit 1
fi

checked=0
alerts=0
ok=0

check_size(){
    ((checked++))
    if [[ -d "$1" ]]; then

        total_space=$(du -sm $1 | awk '{print $1}')  
        if [[ $total_space > $size ]]; then
            ((alerts++))
            status="alert"
        else
            ((ok++))
            status="ok"
        fi
    else
        status="not exists"
    fi

    # Saving inside disk_report.csv
    echo "$1,$total_space,$status" >> disk_report.csv
} 

while read -r dir; do
    check_size "$dir"
done < $file

echo  "===== SUMMARY ====
Checked: $checked 
Alerts: $alerts 
Ok: $ok
"
