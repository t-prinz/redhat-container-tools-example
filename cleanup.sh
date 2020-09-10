#!/bin/bash

echo "Stopping all running containers"
for icont in $(podman ps -q)
do
  podman stop ${icont}
done

echo "Deleting all running containers"
for icont in $(podman ps -a -q)
do
  podman rm ${icont}
done

echo "Deleting the container image"
for icont in $(podman images localhost/httpd:latest -q)
do
  podman rmi ${icont}
done

echo "Removing buildah working containers"
for icont in $(buildah containers -q)
do
  buildah rm ${icont}
done

echo "Deleting the web content file"
if [ -e index.html ]
then
  rm index.html
fi

echo "Deleting kubernetes container definition file"
if [ -e export.yaml ]
then
  rm export.yaml
fi

echo "Deleting systemd configuration file"
if [ -e container-web.service ]
then
  rm container-web.service
fi
