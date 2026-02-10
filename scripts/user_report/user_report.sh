#!/opt/homebrew/bin/bash

##########
# Author: Lokesh Singh
# Date: 10/02/2026
#########

arg=$1

if [ -z "$arg" ]; then
    echo "Usage: ./user_report.sh app.log"
    exit 1
fi

declare -A ok
declare -A fail

user_info() {
    if [ -n "$1" ]; then

        user_name=$(echo "$1" | awk '{print $3}' | cut -d= -f2)
        status=$(echo "$1" | awk '{print $NF}' | cut -d= -f2)

        if [ "$status" == "ok" ]; then
            ((ok["$user_name"]++))
        else
            ((fail["$user_name"]++))
        fi
    fi
}

while read -r log; do
    user_info "$log"
done < "$arg"

echo "===== USER REPORT ====="
echo

# collect all users from both arrays
all_users=($(printf "%s\n" "${!ok[@]}" "${!fail[@]}" | sort -u))

total_error=0
top_failed_user=""

for user in "${all_users[@]}"; do
    user_fail=${fail[$user]:-0}
    if [[ $total_error -lt $user_fail ]];then 
        total_error=$user_fail
        top_failed_user=$user
    fi
    printf "%-6s -> OK:%s FAIL:%s\n" \
        "$user" \
        "${ok[$user]:-0}" \
        "${fail[$user]:-0}"
done

echo "Top Failed User: $top_failed_user ($total_error)"

