#!/bin/sh
set -o errexit
kubectl apply -f postgres-pv.yaml 
kubectl apply -f postgres-pvc.yaml 
kubectl get pvc
helm install local-db -f values.yaml bitnami/postgresql 

