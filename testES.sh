#!/bin/bash



#get ES credentials 
echo step 1:getting ES credentials...
sleep 5
PASSWORD=$(kubectl get secret escluster-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')


#verify connectivity with ES cluster
echo step 2:verifying ES cluster connectivity... 
sleep 5
curl -u "elastic:$PASSWORD" -k "https://localhost:9200"

echo step 3:Displaying ES pods... 
sleep 5
kubectl get pods --selector='elasticsearch.k8s.elastic.co/cluster-name=escluster'



#verify if documents are able to be indexed by the ES cluster
echo step 4: verifying if POST functionality is working for documents.
sleep 5
cat <<EOF | curl -u "elastic:$PASSWORD" -k -X POST "https://localhost:9200/logs-my_app-default/_doc?pretty" -H 'Content-Type: application/json' -d'
{
  "@timestamp": "2099-05-06T16:21:15.000Z",
  "event": {
    "original": "192.0.2.42 - - [06/May/2099:16:21:15 +0000] \"GET /images/bg.jpg HTTP/1.0\" 200 24736"
  }
}'
EOF




#verify if documents are retrievable from the ES cluster
echo step 5:verifying if documents are retrievable from ES cluster
sleep 5
cat <<EOF | curl -u "elastic:$PASSWORD" -k -X GET "https://localhost:9200/logs-my_app-default/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_all": { }
  },
  "sort": [
    {
      "@timestamp": "desc"
    }
  ]
}'
EOF


#clean up test documents and data streams
echo step 6: cleaning up test documents and data streams
sleep 5
curl -u "elastic:$PASSWORD" -k -X DELETE "https://localhost:9200/_data_stream/logs-my_app-default?pretty"



