# Elasticsearch on Kubernetes


### Design decisions
Based on the requirement the following design decisions have been made.
### Tools used to deploy
- Custom resource definition from https://download.elastic.co/downloads/eck/1.9.0/crds.yaml
  - Provides the definition so we could define elasticsearch objects as kubernetes resources
- Operator from https://download.elastic.co/downloads/eck/1.9.0/operator.yaml
  - Provides the definition and methods to manage kubernetes applications
- Shell scripts
  - deployES.sh
     - Performs the creation of CRD, application of the operator, persistent volumes and the creation of the ES cluster
  - testES.sh
     - Performs cluster readiness checks by connecting to the cluster and verifying if POST and GET for ES documents are working. 
  - deleteES.sh
     - Performs ES cluster deletion and cleanup of persistent volumes.

### ES Cluster Configuration
- Cluster name : escluster
- Number of nodes : 3 nodes
-  Volume claim template 
  - Name : elasticsearch-data
  - storage : 5Gi
  - storageClassName: manual (ideal: standard)
    - ideally this would an EBS volume not hosted on the hosts as loss of these hosts due to maintenance will render the data useless. But I don't have aws CLI access to create EBS volumes, ideally AWS EBS CSI driver is also installed.
### Kubernetes cluster configuration
  - 3 persistent volumes
   - Names : elasticsearch-data-0, elasticsearch-data-1, elasticsearch-data-2
   - storage: 5Gi
   - storageClassName: manual (ideal:standard)
   - Ideally connect to AWS EBS (limitation due to lack of AWS CLI access)

### AWS configuration (Create EBS volumes:not done)
  - AWS EBS volumes
## Prerequisites
- kubectl
- kubeconfig context is already pointing to the right cluster

### Verify your connection to Kubernetes

```bash
export KUBECONFIG=<path>
kubectl auth can-i delete pods
```

## Steps to deploy the cluster 
 1. Clone the reposistory 
 ````
 git clone https://github.com/GedriteA/Quickstart-deploy-ES-to-kubernetes.git
 ````
 2. Provide execute permissions for the scripts ./deployES.sh and ./testES.sh 
 ````
 chmod 755 deployES.sh
 chmod 755 testES.sh
 ````
 3. Run the deploy script
  ````
 ./deployES.sh
  ````
 ![deploy](https://user-images.githubusercontent.com/22384690/145718437-9f6e225f-b093-43a6-9586-8cb96c0dcee9.JPG)
 
 4. Wait for the ES cluster to deploy this takes about 10 minutes at the max
 
 5. Port forward ES service to your local machine
 ````
 kubectl port-forward service/escluster-es-http 9200
 ````
![forward](https://user-images.githubusercontent.com/22384690/145718528-fbdc4f17-8652-44bd-8d17-a662e839a946.JPG)

 6. Run the test suite
 ````
 ./testES.sh
 ````
![testes](https://user-images.githubusercontent.com/22384690/145718633-029765bc-bed9-4d16-b4b4-f20cc47091ab.JPG)


## Steps to delete the cluster
 1. Change directory to esclusterdeletion
 ````
 cd esclusterdeletion
 ````
 2. Provide execute permissions for ./deleteES.sh
 ````
 chmod 755 deleteES.sh
 ````
 3. Run the deletion script
 ````
 ./deleteES.sh
 ```` 
 ![asdf](https://user-images.githubusercontent.com/22384690/145718788-de0be417-0e37-4a39-ae81-8640d27afe57.JPG)
