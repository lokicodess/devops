#!/bin/bash

file=$1

awk '
{
status=$9

if(status ~ /^2/) success++
if(status ~ /^4/) four_Error++
if(status ~ /^5/) five_Error++

ip_count[$1]++
url_count[$7]++
}

END{
print "Total Request:", NR
print "Success (200):", success
print "Failures (!=200):", NR-success

for(ip in ip_count){
    if(ip_count[ip] > max_ip){
        max_ip = ip_count[ip]
        top_ip = ip
    }
}

print "Top IP:", top_ip "->", max_ip

for(url in url_count){
    if(url_count[url] > max_url){
        max_url = url_count[url]
        top_url = url
    }
}

print "Top URL:"
print top_url "->", max_url

print "4xx Errors:", four_Error
print "5xx Errors:", five_Error
}
' "$file"
  
