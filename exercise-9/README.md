# Persistent volumes

This exercise can be done in 2 ways depending on where you are running the exercise:
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
- launch a nginx pod and go open the home page of the pod:
  - in order to get this working: you will need to create a port forward (port 8080 local will map on port 80 of pod): `kubectl port-forward nginx 8080:80`. 
    - Not in gitpod: go to `127.0.0.1:8080` to reach the nginx home page
    - when using gitpod: you can open the ports tab and click on the browser icon next to port 8080 to open the correct url
