Docker Base Image
===

This image should install all prerequisites for opencoral.

Building
---
docker build -t docker.nanofab.utah.edu:5000/chef-opencoral-base .
docker run -d --name coralbase chef-opencoral-base
docker export coralbase | docker import - docker.nanofab.utah.edu:5000/chef-opencoral-base

