# [warhorse/docker-parrot-html5](https://github.com/war-horse/docker-parrot-html5)

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/warhorse/docker-parrot-html5)
[![Docker](https://github.com/warhorse/docker-parrot-html5/actions/workflows/docker-publish.yml/badge.svg?branch=v1.0.1)](https://github.com/warhorse/docker-parrot-html5/actions/workflows/docker-publish.yml)
![License](https://img.shields.io/github/license/warhorse/docker-parrot-html5)
![Commit](https://img.shields.io/github/last-commit/warhorse/docker-parrot-html5)

[Parrot OS](https://www.parrotsec.org/) - Parrot OS, the flagship product of Parrot Security is a GNU/Linux distribution based on Debian and designed with Security and Privacy in mind. It includes a full portable laboratory for all kinds of cyber security operations, from pentesting to digital forensics and reverse engineering, but it also includes everything needed to develop your own software or keep your data secure.


![Parrot OS](images/parrot_os_logo.png)

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=parrot-html5 \
  -e TZ=Europe/London \
  -e VNC_PASSWORD=PASSWORD \
  -e ROOT_PASSWORD=PASSWORD \
  -e XUSER_PASSWORD=PASSWORD \
  -p 80:6080 \
  -v <path to data>:/home/xuser/files \
  --restart unless-stopped \
  --shm-size 2g \
  --cap-add=NET_ADMIN \
  warhorse/parrot-html5
```

### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
  parrot-html5:
    build: ./
    image: parrot-html5
    container_name: parrot-html5
    shm_size: 2gb
    ports:
    - 80:6080
    environment:
    - VNC_PASSWORD=PASSWORD
    - ROOT_PASSWORD=PASSWORD
    - XUSER_PASSWORD=PASSWORD
    cap_add:
      - NET_ADMIN
    restart: always
    volumes:
    - ./home:/home/xuser/files
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 80` | The port for HTTP traffic |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London|
| `-e VNC_PASSWORD=PASSWORD` | Specify a VNC password|
| `-e ROOT_PASSWORD=PASSWORD` | Specify a root user password|
| `-e XUSER_PASSWORD=PASSWORD` | Specify a xuser password|
| `-v ./home:/home/xuser/files` | User home folder |

&nbsp;
## Application Setup

Access noVNC at the webui at `<your-ip>:80`



## Support Info

* Shell access whilst the container is running: `docker exec -it parrot-html5 /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f parrot-html5`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/warhorse/docker-parrot-html5.git
cd docker-parrot-html5
docker build \
  --no-cache \
  --pull \
  -t warhorse/docker-parrot-html5:latest .
```