# Start with Kustomize

## Steps
- Convert the cat webapp + service to a Kustomize resource (add kustomization.yaml) in a base folder
-- run kubectl kustomize ./ to see the resulting resources
- create environment specific setup (dev, prod) as directories
-- dev environment: 1 instance, clusterip as service in your own namespace with label env: dev
-- prod environment: 2 instances, nodeport as service in your own namespace with label env:prod
- Change the tag of the image in both environments
-- latest tag for dev environment
-- tag 1.1 for prod environment
