![Wallabag](https://raw.githubusercontent.com/wallabag/logo/master/_default/typo-horizontal/png/sm/logo-typo-horizontal-black-no-bg-no-border-sm.png)

[![Build Status](https://drone.xataz.net/api/badges/xataz/docker-wallabag/status.svg)](https://drone.xataz.net/xataz/docker-wallabag)
[![](https://images.microbadger.com/badges/image/xataz/wallabag.svg)](https://microbadger.com/images/xataz/wallabag "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/xataz/wallabag.svg)](https://microbadger.com/images/xataz/wallabag "Get your own version badge on microbadger.com")

> This image is build and push with [drone.io](https://github.com/drone/drone), a circle-ci like self-hosted.
> If you don't trust, you can build yourself.

## Tag available
* 2.3.0, 2.3, 2, latest [(Dockerfile)](https://github.com/xataz/dockerfiles/tree/master/transmission/Dockerfile)

## Description
What is [wallabag](http://www.transmissionbt.com/) ?

wallabag is a self-hostable PHP application allowing you to not miss any content anymore. Click, save and read it when you can. It extracts content so that you can read it when you have time.

## Features
* Support install on sqlite, mysql and postgres
* No **ROOT** process
* Support Redis and RabbitMQ

## Bug issue
* Postgresql not support by wallabag 2.3.0 ([#3479](https://github.com/wallabag/wallabag/issues/3479))

## Build Image

```shell
docker build -t xataz/wallabag github.com/xataz/docker-wallabag
```

## Configuration
### Environments
| Variable Name | Description | default | value |
| ------------- | ----------- | ------- | ----- |
| UID | uid use to launch wallabag | 991 | valid UID |
| GID | gid use to launch wallabag | 991 | valid GID |
| DB_TYPE | Type of database | sqlite | sqlite, pgsql or mysql |
| DB_HOST | Hostname or IP of database host | wallabag-db | valid IP, container name or hostname |
| DB_PORT | Port of database | ~ | Valid port number |
| DB_NAME | Database name | wallabag | Valid database name |
| DB_USER | Database user | wallabag | Valid database user |
| DB_PASS | Database user password | ~ | Valid password |
| MAIL_HOST | smtp server address | 127.0.0.1 | Valid smtp server |
| MAIL_USER | smtp username | ~ | Valid username for smtp server |
| MAIL_PASS | smtp password | ~ | Valid password for smtp server |
| MAIL_ADRESS | Mail address for contact | wallabag@mydomain.tld | Valid mail address |
| DOMAIN_NAME | Domain to use for wallabag access | wallabag.mydomain.tld | Valid domain name |
| SECRET | Secret for php sessions | ovkdslhHIDMSkgdklDSMIKHDgfkldf | Randomize |
| ENABLE_REGISTRATION | Enable user registration | false | true or false |
| ENABLE_RABBITMQ | Enable rabbitmq for asynchronous tasks | false | true or flase |
| RABBITMQ_HOST | Rabbitmq hostname | rabbitmq | Valid IP, container name or hostname |
| RABBITMQ_PORT | Rabbitmq database port | 5672 | Valid port number |
| RABBITMQ_USER | Rabbitmq database user | guest | Valide database user |
| RABBITMQ_PASS | Rabbitmq database password | guest | Valid password |
| ENABLE_REDIS | Enable redis for asynchronous tasks | false | true or flase |
| REDIS_HOST | Redis hostname | redis | Valid IP, container name or hostname |
| REDIS_PORT | Redis database port | 6379 | Valid port number |
| REDIS_PASS | Redis password | null | Valide password |

### Volumes
* /data : Sqlite database emplacement
* /app/wallabag/web/assets/images : Store content images

### Ports
* 8080

## Usage
### Run with sqlite
```shell
$ docker run -d -p 8080:8080 \
    -v /docker/wallabag/db/:/data \
    -v /docker/wallabag/img:/app/wallabag/web/assets/images \
    -e DB_TYPE=sqlite \
    xataz/wallabag
```

### Run with mariadb
```shell
$ docker run -d --name wallabag-db \
    -v /docker/wallabag/db:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=wallabag \
    -e MYSQL_DATABASE=wallabag \
    -e MYSQL_USER=wallabag \
    -e MYSQL_PASSWORD=wallabag \
    mariadb
$ docker run -d -p 8080:8080 \
    -v /docker/wallabag/img:/app/wallabag/web/assets/images \
    --link wallabag-db:wallabag-db \
    -e DB_TYPE=mysql \
    -e DB_HOST=wallabag-db \
    -e DB_PORT=3306 \
    -e DB_USER=wallabag \
    -e DB_PASS=wallabag \
    -e DB_NAME=wallabag \
    xataz/wallabag
```


### Enable asynchronous tasks
More information [here](https://github.com/wallabag/doc/blob/master/en/admin/asynchronous.md)

Exemple for enable asynchronous pocket import with redis :
```shell
docker exec -ti -u wallabag wallabag_container sh -c "cd /app/wallabag && php bin/console wallabag:import:redis-worker -e=prod pocket -vv"
```

## Contributing
Any contributions, are very welcome !