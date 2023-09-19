# Kustomize with configmap and secret

## Steps
- Start from a basic nginx deployment
- Generate a configmap based on the prometheus yaml file and mount it as a volume
- Generate a secret based on a env file and mount it as env variables
- update your secret and configmap and see what happens?
