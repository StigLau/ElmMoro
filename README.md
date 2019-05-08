What do do
===========

gcloud info
gcloud auth login
docker build -t kompostedit .
docker run -p 3000:3000 -it kompostedit

docker tag kompostedit eu.gcr.io/makeshitapp/kompostedit
gcloud docker -- push eu.gcr.io/makeshitapp/kompostedit

gcloud container images list-tags eu.gcr.io/makeshitapp/kompostedit



#Remove all containers
docker rm `docker ps --no-trunc -aq`


gcloud container clusters get-credentials cluster-1 --zone us-west1-a --project makeshitapp
kubectl create -f komposter.yml


kubectl run komposter --replicas=1 --labels="run=load-balancer-example" --image=eu.gcr.io/makeshitapp/kompostedit:latest  --port=3000
kubectl get deployments komposter
kubectl describe deployments komposter

kubectl expose deployment komposter --type=LoadBalancer --name=komposter-service
https://kubernetes.io/docs/tutorials/stateless-application/expose-external-ip-address/

All Your Base
=============
https://e82fe3cb-c41e-4b17-b0d1-a5f3d0bcb833-bluemix.cloudant.com/dashboard.html#/_all_dbs


Ting som må fikses:
* Editing Source -> Evaluate Checksum. Ikke testet ut ordentlig
* Komposition; sider funker ikke
    * Store Komposition
    * Delete Komposition
    * Show Json
    * Create video
    
    
Nye features:
    * Bruke bare ID til sources. Segmenter, Sources osv. ikke bruke fulle URL'er