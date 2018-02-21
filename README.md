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


kubectl create -f komposter.yml