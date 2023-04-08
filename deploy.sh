#!/bin/bash

docker build -t bardoclub/multi-client:latest -t bardoclub/multi-client:"${SHA}" -f ./client/Dockerfile.dev ./client
docker build -t bardoclub/multi-server:latest -t bardoclub/multi-server:"${SHA}" -f ./server/Dockerfile.dev ./server
docker build -t bardoclub/multi-worker:latest -t bardoclub/multi-worker:"${SHA}" -f ./worker/Dockerfile.dev ./worker

docker push bardoclub/multi-client:latest
docker push bardoclub/multi-server:latest
docker push bardoclub/multi-worker:latest

docker push bardoclub/multi-client:"${SHA}"
docker push bardoclub/multi-server:"${SHA}"
docker push bardoclub/multi-worker:"${SHA}"

kubectl apply -f k8s
kubectl set image deployments/client-deployment client=bardoclub/multi-client:"${SHA}"
kubectl set image deployments/server-deployment server=bardoclub/multi-server:"${SHA}"
kubectl set image deployments/worker-deployment worker=bardoclub/multi-worker:"${SHA}"