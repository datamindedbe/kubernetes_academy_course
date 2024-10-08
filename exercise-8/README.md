# Ingress

## Steps

Setup ingress for 2 deployments of our cats deployment with different images.

# Local setup
- cat0.example.com cat0-svc
- cat1.example.com cat1-svc

Make sure your local kubernetes cluster has ingress enabled
Make sure to change the /etc/hosts with the correct entries such that they are routable

# Eks cluster

## Help specifying your ingress resource

### Required annotations
```
nginx.ingress.kubernetes.io/rewrite-target: /
alb.ingress.kubernetes.io/scheme: "internet-facing"
alb.ingress.kubernetes.io/target-type: "ip"
external-dns.alpha.kubernetes.io/hostname: "<first-username>-cat0.k8sacademy.waydata.be,<first-username>-cat1.k8sacademy.waydata.be"
alb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:eu-west-1:299641483789:certificate/5329aacf-d233-4409-b6b7-f5ea777c87c9"
```
For more details on the supported annotations, take a look at the aws load balancer controller: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/

Note: if your target-type is instance, your services must be a NodePort as it then uses the nodeport to go to your services

### Specify ingressClassName

`ingressClassName: "alb"`

## Define the rules
You must specify two rules that forward an incoming request to the respective service.
host parameter looks as follows: `<first-username>-cat-<index>.k8sacademy.waydata.be`

An ingress template can be generated using: `kubectl create ingress simple --rule="niels-cat0.k8sacademy.waydata.be/=cat0-svc:80" --class=alb --dry-run=client -o yaml > ingress.yaml`