# Kubernetes basics

This repository contains the exercises used in the kubernetes course.
It has a folder for each exercise and the solution is available in a separate directory.

## Using a realworld kubernetes cluster 

Unfortunately microk8s cannot be installed on a docker container, so it is also not available through gitpod.
For this reason I manage a real kubernetes cluster, which is running on AWS, to be used for this session.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/datamindedbe/kubernetes_academy_course)

Usage:
- I will give the info on how to connect to the cluster (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY)
  - run the following command in gitpod: `source expose_env_vars.sh <ACCESS_KEY_ID> <SECRET_ACCESS_KEY>`
  - run then: `./connect_cluster.sh k8s-bn54I8`

- Create a namespace for yourself and make sure to create *all resources in your own namespace* such that you do not impact each other.
```
kubectl create namespace <your-first-name>
kubens <select your namespace>
```

## Alternative: perform exercises locally

I can recommend microk8s to simulate a k8s cluster on your local machine.
More info on installing it can be found here: https://microk8s.io/docs/getting-started

## Content

- Exercise 1: using pod spec
- Exercise 2: kubernetes commands
- Exercise 3: livecycle pods
- Exercise 4: deployments
- Exercise 5: secrets
- Exercise 6: configmaps
- Exercise 7: services
- Exercise 8: ingress
- Exercise 9: persistent volumes
- Exercise 10: stateful sets
- Exercise 11: init containers
- Exercise 12: daemonsets
- Exercise 13: rbac
- Exercise 14: Kustomize basic
- Exercise 15: Kustomize with generated configmap and secret
- Exercise 16: Using a helm chart
- Exercise 17: Creating a helm chart

