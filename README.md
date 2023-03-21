# load testing apps at local k8s

1. create a local K8s cluster (here we use Kind, similiar to Minikube) with local image registry (ie, local ECR)
2. pull images from AWS ECR and push to local registry
3. deploy a Postgres DB at local cluster (because we want to avoid RDS in this local experiment)
4. decide the load testing parameters
5. create SNS topics and SQS queues
6. deploy apps to local cluster
7. deploy jmeter and grafana to local cluster
8. generate testing CSV files for testing (HTTP)
9. run load testing
10. generate testing CSV files for testing (SQS)
10. run load testing


## Steps

### Prerequisite

1. obvisouly all the k8s, K9s stuff
2. Helm

### Local Cluster

First create a Kind cluster (https://kind.sigs.k8s.io/) with a local registry at localhost:5005

````sh
cd kind
./create_cluster_with_local_registry.sh
cd ..
````

optional- create namespace
````sh
kubectl apply -f namespace.yaml
````
### Create a Postgres pod

We don't want to bother RDS for our local testing...

````sh
cd local-db
./create_db.sh
cd ..
````

Above will create a Postgres Db (snapp/snapp) and rumi_reporting_test database.

###  get app1 and app2 images from ECR and push to local registry

first run Bento to get access to Snapdocs cluster

````sh
docker pull .....dkr.ecr.us-west-2.amazonaws.com/app
docker tag .......dkr.ecr.us-west-2.amazonaws.com/app localhost:5005/app
docker push localhost:5005/app

docker pull .......dkr.ecr.us-west-2.amazonaws.com/app2:[tag]
docker tag .......dkr.ecr.us-west-2.amazonaws.com/app2:[tag] localhost:5005/app2:[tag]
docker push localhost:5005/app2:[tag]
````

### create SNS Topoc, SQS Queue and Subscriptions


### deploy apps to cluster


install the chart

````sh
helm install app1 ./app1-chart/
helm install app2 ./app2-chart/
````

### database migrate

apply the job to migrate database of app2

````sh
kubectl apply app2-db-migrate -f 
````

### Quick Local Test

first portforward apps from k8s to local

then generate testing CSV files

### create the jmeter-k8s including jmeter, graphana, influxdb, and telegraf

````sh
cd jmeter-k8s
kubectl create -R -f k8s/
 ````

### Port forwarding Graphana

use admin/.... to access

### Use Jmeter to load test, start the job from local
 
 ````sh
./start_test2.sh -j app1.jmx -n default -c -m -i 2 -r
 ````

### destory

````sh
helm uninstall app2            
helm uninstall local-db      
helm uninstall app1
kubectl delete -R -f k8s/
kind delete cluster --name mykind
````