# Services

## Gitpod and Eks network setup

If you are running locally, through microk8s or k3s, you can ignore this section and go straight to the exercise.
In order to troubleshoot some networking issues, it is best to have a look at the network setup when using gitpod with eks.

![](./networkSetupGitpodEks.drawio.png "network-setup")

## Steps

- create a service for the previous deployment
  - when in gitpod: use a loadbalancer service with the following annotations:
```
    service.beta.kubernetes.io/aws-load-balancer-type: "external"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "ip"
```
- look up the external dns for the service
  - when running locally: go to the homepage to see the content
  - when in gitpod: issue port-forward command to access service locally: `kubectl port-forward service/cat-svc 8080:80` where local port 8080 and service port is 80.
    Now you can go to the ports tab and click on the browser icon next to port 8080.
- change cat index of deployment and do rolling upgrade
- refresh clusterIP multiple times

More information on the annotations can be found on the AWS Load balancer controller: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/

Note: it might take a couple of minutes (2-3min) before the dns record can be resolved. Also the loadbalancer on AWS takes some time to startup