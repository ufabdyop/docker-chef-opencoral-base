Docker Base Image
===

This image should install all prerequisites for opencoral.

Building
---
docker build -t chef-opencoral-base .
docker run -d --name coralbase chef-opencoral-base
docker export coralbase | docker import - chef-opencoral-base

