# Rbac

I created a role with binding and service account to get/list pods in default namespace.
I attached the correct service account to the kubectl pod such that it can list, get all pods in the default namespace.

## Steps

- exec in the kubectl pod and list pods in default namespace (this should work)
- try to list pods in a different workspace (this should fail)
- Create a clusterRole and clusterRoleBinding such that the kubectl pod can list/get/delete pods in all namespaces
- Test whether you changes work by attaching the ClusterRole to the kubectl pod
