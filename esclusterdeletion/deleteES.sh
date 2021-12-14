#!/bin/bash

read -r -p "Are You Sure? [Y/n] " input
 
case $input in
    [yY][eE][sS]|[yY])
 echo deleting ES cluster and PV
 kubectl get namespaces --no-headers -o custom-columns=:metadata.name \
 | xargs -n1 kubectl delete elastic --all -n
 kubectl delete -f https://download.elastic.co/downloads/eck/1.9.0/operator.yaml
 kubectl delete -f https://download.elastic.co/downloads/eck/1.9.0/crds.yaml
 kubectl delete pv elasticsearch-data-0
 kubectl delete pv elasticsearch-data-1
 kubectl delete pv elasticsearch-data-2
 ;;
    [nN][oO]|[nN])
 echo "Operation cancelled"
       ;;
    *)
 echo "Invalid input..."
 exit 1
 ;;
esac