#!/usr/bin/env bash

set -x

export AWS_DEFAULT_REGION=eu-west-1
aws eks update-kubeconfig --name $1
