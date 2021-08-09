#!/usr/bin/env bash

raw_git="raw.githubusercontent.com/sysnet4admin/IaC/master/manifests" 

kubectl delete -f https://$raw_git/svc/metallb-0.9.6.yaml
kubectl delete -f https://$raw_git/svc/metallb-l2config.yaml
kubectl delete secret memberlist -n metallb-system

echo "MetalLB uninstalled successfully"


