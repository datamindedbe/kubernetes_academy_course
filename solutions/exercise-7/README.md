# Services

## Local setup
- create a cluster-ip service for the previous deployment
- load the clusterIP of service
- change cat index of deployment and do rolling upgrade
- refresh clusterIP multiple times


## Gitpod and Eks network setup

If you are running locally, through microk8s or k3s, you can ignore this section and go straight to the exercise.
In order to troubleshoot some networking issues, it is best to have a look at the network setup when using gitpod with eks.

![](./networkSetupGitpodEks.drawio.png "network-setup")


### cluster-ip
- create a cluster-ip service for the previous deployment
- use port forwarding to access the service
  `kubectl port-forward service/cat-svc 8080:80` where local port 8080 and service port is 80.
  Now you can go to the ports tab and click on the browser icon next to port 8080.
- see whether you can see the cat homepage in your browser

### load-balancer service
- change the service to a loadbalancer service for the previous deployment
```
    service.beta.kubernetes.io/aws-load-balancer-type: "external"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:eu-west-1:299641483789:certificate/e8045032-8856-4b88-a773-45bec46915de"
    external-dns.alpha.kubernetes.io/hostname: "<first-username>-cat-svc.k8sacademy.waydata.be"
```
- change cat index of deployment and do rolling upgrade
- refresh url multiple times. Do you see the image changing and do you understand why?

More information on the annotations can be found on the AWS Load balancer controller: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/

Note: it might take a couple of minutes (2-3min) before the dns record can be resolved. Also the loadbalancer on AWS takes some time to startup

Note2: if you want to use https, you must also specify this port in your service (443) next to port 80