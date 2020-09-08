#!/bin/bash

buildah from registry.access.redhat.com/ubi8/ubi:latest

docker images

# Note the CONTAINER NAME

buildah containers

buildah run ubi-working-container -- yum -y install httpd

echo 'Welcome to the RHEL8 workshop!' > index.html
buildah copy ubi-working-container index.html /var/www/html/index.html

buildah config --cmd "/usr/sbin/httpd -D FOREGROUND" ubi-working-container

buildah config --port 80 ubi-working-container

buildah commit ubi-working-container httpd

podman run -d -p 8080:80 httpd

podman ps

podman top -l

curl -s http://localhost:8080

podman stop -a

podman ps -l

podman generate kube $(podman ps --quiet -l) > export.yaml
