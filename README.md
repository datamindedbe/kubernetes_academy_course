# Kubernetes basics

This repository contains the exercises used in the kubernetes course.
It has a folder for each exercise and the solution is available in a separate directory.

## Running tests locally

I can recommend microk8s to simulate a k8s cluster on your local machine. 
More info on installing it can be found here: https://microk8s.io/docs/getting-started

## Using a realworld cluster

Unfortunately microk8s cannot be installed on a docker container, so it is also not available through gitpod.
As a backup I created a kubernetes cluster in my aws account, which we can use for this session.

Usage:
- I will give info on how to connect to the cluster (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY)
  - run the following command in gitpod: source `connect_cluster.sh <ACCESS_KEY_ID> <SECRET_ACCESS_KEY> <CLUSTER_NAME>`
- Create a namespace for yourself and make sure to create all resources in your own namespace such that you do not impact each other.
- Use the following link to open the repo in gitpod:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/datamindedbe/kubernetes_academy_course)

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

