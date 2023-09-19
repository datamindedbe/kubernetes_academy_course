# Creating a chart

## Steps
- helm create <chart-name>
-- remove all files that you do not need from templates directory
-- remove all parameters we do not use from the deployment, service file
- template deployment.yaml (image tag, namespace, label, replicas, serviceType)
- create 2 directories: dev, prod with values for the templated variables as done with kustomize
-- env: dev|prod label
-- prod: 2 replicas, dev 1
-- namespace: <your-namespace>
-- image tag: latest for dev and 1.0 for prod
-- service type: clusterip for dev and Nodeport for prod

## Test your config
`helm install <release-name> --namespace <your-namespace> --dry-run --debug <chart-directory> --values <values-file>`
