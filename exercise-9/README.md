# Persistent volumes

- if you are using a local kubernetes cluster (like microk8s or k3s), you can use the hostPath property to mount a local directory
- if you are using eks as kubernetes cluster you should use the gp3 storage class for your persistent volume claim

## Steps

### For local setup with microk8s
- launch a nginx pod and go open the home page (port 80) in the browser
  - it should mention something like: welcome to nginx...
- create a custom index.html and put it at /tmp/storage/data
- create nginx pod with volume mount to the host
  - mount the /tmp/storage/data folder under /usr/share/nginx/html/ as that is where nginx looks for the index.html file by default
- Do the same as before but now using a pv and pvc using same `/tmp/storage/data` directory

### For setup using an eks cluster using gitpod
On eks we created a storageclass called gp3, which can be used
- create a pvc for your gp3 storage class
- use the pvc in your nginx pod and mount the volume under the /tmp directory of the container
- check whether it was successful by running `kubectl exec -it <pod> sh` and run `df -h` to inspect whether the disk was correctly mounted