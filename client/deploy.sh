#!/bin/bash


docker build -t barroz/multi-client:latest -t barroz/multi-client:"${SHA}" -f ./client/Dockerfile ./client
docker build -t barroz/multi-server:latest -t barroz/multi-server:"${SHA}" -f ./server/Dockerfile ./server
docker build -t barroz/multi-worker:latest -t barroz/multi-worker:"${SHA}" -f ./worker/Dockerfile ./worker

docker push barroz/multi-client:latest
docker push barroz/multi-server:latest
docker push barroz/multi-worker:latest

docker push barroz/multi-client:"${SHA}"
docker push barroz/multi-server:"${SHA}"
docker push barroz/multi-worker:"${SHA}"

kubectl apply -f k8s
kubectl set image deployments/client-deployment client=barroz/multi-client:"${SHA}"
kubectl set image deployments/server-deployment server=barroz/multi-server:"${SHA}"
kubectl set image deployments/worker-deployment worker=barroz/multi-worker:"${SHA}"
