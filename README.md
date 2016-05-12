## Registry VM

* create registry host  
`docker-machine create registry --driver virtualbox
`

### On OSX

* generate self signed certificate  
`mkdir -p certs && openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key -x509 -days 10000 -out certs/domain.crt`

be sure the host name is ***'atlantis'***

* Dockerfile

~~~
FROM registry:2

RUN mkdir -p /registry

ADD certs/domain.crt /registry/certs/domain.crt
ADD certs/domain.key /registry/certs/domain.key

ENV REGISTRY_HTTP_TLS_CERTIFICATE=/registry/certs/domain.crt
ENV REGISTRY_HTTP_TLS_KEY=/registry/certs/domain.key

EXPOSE 5000
~~~

* docker-compose.yml

~~~
version: '2'
services:
  registry:
    build: .
    container_name: registry
    ports:
      - 5000:5000
~~~

### boot2docker

* ssh to docker vm  
`docker-machine ssh registry`

* insecure-registry: /var/lib/boot2docker/profile  

~~~
 EXTRA_ARGS='  
    --label provider=virtualbox  
    --insecure-registry atlantis:5000  
'
~~~

* restart docker deamon  
`/etc/init.d/docker restart`


## Docker deamon
1. copy domain.crt   
`cp domain.crt /etc/docker/certs.d/atlantis:5000/ca.crt`

2. restart docker deamon  
`/etc/init.d/docker restart`

3. push image  
`docker tag postgres atlantis:5000/postgres`  
`docker push atlantis:5000/postgres`