#!/bin/bash
docker ps -q | xargs -n 1 docker inspect --format '{{.Name}} {{range $net, $setting := .NetworkSettings.Networks}}{{$net}} {{$setting.IPAddress}} {{end}}' | awk '{name=substr($1,2); for (i=2; i<=NF; i+=2) printf "%-40s %-20s %s\n", name, $i, $(i+1)}'

