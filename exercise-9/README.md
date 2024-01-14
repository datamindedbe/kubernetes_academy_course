# Persistent volumes

- if you are using a local kubernetes cluster (like microk8s or k3s), you can use the hostPath property to mount a local directory
- if you are using eks as kubernetes cluster you should use the gp3 storage class for your persistent volume claim

## For local setup with microk8s
- launch a nginx pod and go open the home page (port 80) in the browser
  - it should mention something like: welcome to nginx...
- create a custom index.html and put it at /tmp/storage/data
- create nginx pod with volume mount to the host
  - mount the /tmp/storage/data folder under /usr/share/nginx/html/ as that is where nginx looks for the index.html file by default
- Do the same as before but now using a pv and pvc using same `/tmp/storage/data` directory

## For setup using an eks cluster using gitpod

### emptydir volumes
- create an nginx pod with a volumemount `/cache` which uses the `emptyDir` volume type
- run the following cmd: `kubectl exec -it nginx-webserver -- /bin/sh -c 'echo "Hello, Kubernetes!" > /cache/myfile.txt'`
- check the data using the following command: `kubectl exec -it nginx-webserver -- /bin/cat /cache/myfile.txt`
- delete your pod
- see whether you can still  access the data: `kubectl exec -it nginx-webserver -- /bin/cat /cache/myfile.txt`
- recreate the pod
- see whether you can still  access the data: `kubectl exec -it nginx-webserver -- /bin/cat /cache/myfile.txt`

### persistent volumes
On eks I created a storageclass called gp3, which you should
- create a pvc for your gp3 storage class
  Note: pv for pvc is only created after using it in a pod. Before that it remains in the Pending phase
- use the pvc in your nginx pod (with livenessprobe) and mount the volume under the `/var/log/nginx` directory of the container, which is where the access logs are stored
- check whether it was successful by running `kubectl exec -it <pod> bash` and run `df -h` to inspect whether the disk was correctly mounted
- check the access logs in file `/var/log/nginx/access.log`. Do you understand where the entries come from?
- recreate the pod
- check whether the previous access logs still exist in `/var/log/nginx/access.log`