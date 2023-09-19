#!/usr/bin/env bash

set -x

export AWS_DEFAULT_REGION=eu-west-1
CLUSTER_NAME='dummy'
if [ "$#" -ne 1 ]; then
  CLUSTER_NAME='k8s-bn54I8'
else
  CLUSTER_NAME=$1
fi

aws eks update-kubeconfig --name $CLUSTER_NAME
