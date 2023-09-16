# instructor setup

## DNS domain
I use my own domain for which I create a subdomain.
TOOD: maybe we should create a hosted zone for playground.dataminded.be or something
Then we can register multiple zones under there

At the moment: add the route53 ns servers to godady in my case after creating the hosted zone.
-> add NS records for prefix: k8sacademy with value the ns servers provided by aws
-> do not specify the full subdomain but only the subdomain prefix.