#!/bin/bash


#Create CRDS 
echo step 1: creating Custom resource definitions for ES
sleep 2
kubectl create -f https://download.elastic.co/downloads/eck/1.9.0/crds.yaml

#Apply operator
echo step 2: Applying operator.yaml
sleep 2
kubectl apply -f https://download.elastic.co/downloads/eck/1.9.0/operator.yaml

echo step 3: Create persistent volumes

echo creating PV 1
sleep 2
#create PV 1
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: elasticsearch-data-0
  namespace: default
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi #Size of the volume
  accessModes:
    - ReadWriteOnce #type of access
  persistentVolumeReclaimPolicy: Delete
  hostPath:
    path: "/mnt/disk1" #host location
EOF

echo creating PV 2
sleep 2
#create PV 1
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: elasticsearch-data-1
  namespace: default
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi #Size of the volume
  accessModes:
    - ReadWriteOnce #type of access
  persistentVolumeReclaimPolicy: Delete
  hostPath:
    path: "/mnt/disk1" #host location
EOF

echo creating PV 3
sleep 2
#create PV 1
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: elasticsearch-data-2
  namespace: default
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi #Size of the volume
  accessModes:
    - ReadWriteOnce #type of access
  persistentVolumeReclaimPolicy: Delete
  hostPath:
    path: "/mnt/disk1" #host location
EOF




#Create ES cluster named escluster with 3 nodes
echo step 4: Creating ES cluster with 3 nodes
sleep 2
cat <<EOF | kubectl apply -f -
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: escluster
spec:
  version: 7.16.0
  nodeSets: 
  - name: default
    count: 3
    volumeClaimTemplates:
    - metadata:
        name: elasticsearch-data # Do not change this name unless you set up a volume mount for the data path.
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 5Gi
        storageClassName: manual
    config:
      node.store.allow_mmap: false
EOF

echo Cluster creation ongoing, please wait for about 5 minutes before verifying if the cluster works using testES.sh
