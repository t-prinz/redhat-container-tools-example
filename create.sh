#!/bin/bash

echo ""
echo "********"
echo "Obtaining RHEL 8 Universal Base Image"
echo "********"
echo ""
buildah from registry.access.redhat.com/ubi8/ubi:latest

echo ""
echo "********"
echo "List working containers; note the CONTAINER NAME"
echo "********"
echo ""
buildah containers

echo ""
echo "********"
echo "Installing Apache httpd using yum"
echo "********"
echo ""
buildah run ubi-working-container -- yum -y install httpd

echo ""
echo "********"
echo "Creating the web content - index.html"
echo "********"
echo ""
echo 'Welcome to the RHEL8 web server!' > index.html
buildah copy ubi-working-container index.html /var/www/html/index.html

echo ""
echo "********"
echo "Specifying the command for the container to run"
echo "********"
echo ""
buildah config --cmd "/usr/sbin/httpd -D FOREGROUND" ubi-working-container

echo ""
echo "********"
echo "Exposing the container port (80)"
echo "********"
echo ""
buildah config --port 80 ubi-working-container

echo ""
echo "********"
echo "Commit the buildah image"
echo "********"
echo ""
buildah commit ubi-working-container httpd

echo ""
echo "********"
echo "Run the container - map local port 8080 to container port 80"
echo "********"
echo ""
podman run --name=web -d -p 8080:80 httpd

echo ""
echo "********"
echo "List running containers"
echo "********"
echo ""
podman ps

echo ""
echo "********"
echo "List processes running inside of containers"
echo "********"
echo ""
podman top -l

echo ""
echo "********"
echo "Test the web server"
echo "********"
echo ""
curl -s http://localhost:8080

echo ""
echo "********"
echo "Generate a kubernetes container definition"
echo "********"
echo ""
podman generate kube $(podman ps --quiet -l) > export.yaml

echo ""
echo "********"
echo "Generate a systemd configuration file"
echo "********"
echo ""
# podman generate systemd --name web -f
podman generate systemd --name web > container-web.service
