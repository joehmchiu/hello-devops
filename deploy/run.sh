#!/bin/sh

export PATH="$PATH:/usr/local/bin"

workdir=/Users/joechiu/demo/mongo-api
nn=0

function say {
  ((nn=$nn+1))
  echo "$nn. $1"
}
say "stop minikube"
minikube stop
say "restart minikube"
minikube start --vm=true --driver=hyperkit

say "repo: cd /Users/joechiu/mac/demo/mongo-api/"
cd $workdir

say "evaluate and localize docker environment"
# eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)
say "build docker image"
docker build . -t mongo-api

say "deploy docker image to kubernetes cluster"
kubectl create -f 1.deploy.yml
say "scale the replica sets"
kubectl scale deploy mongo-api --replicas 3
for i in {1..5}; do kubectl get deploy,po; sleep 3; done

say "expose the deployment service"
kubectl expose deploy mongo-api --type="LoadBalancer" --target-port=8600 --load-balancer-ip='192.168.64.16'

URL=$(minikube service --url mongo-api)
say "export $URL to environment"
export URL=$URL
say "dump $URL to /tmp/url"
echo $URL > /tmp/url

PO=$(kubectl get pods | tail -n1 | awk '{print $1}')
say "forwarding POD: $PO port from 8600 to 9090"
kubectl port-forward $PO 9090:8600&

say "DONE"
