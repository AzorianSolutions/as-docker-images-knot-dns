# Knot Nameserver packaged by [Azorian Solutions](https://azorian.solutions)

Knot DNS is a high-performance authoritative-only DNS server which supports all key features of the modern domain name system.

[Knot Nameserver Website](https://www.knot-dns.cz/)

[Knot Nameserver Documentation](https://www.knot-dns.cz/docs/3.1/html/index.html)

## Quick reference

- **Maintained by:** [Matt Scott](https://github.com/AzorianSolutions)
- **Github:** [https://github.com/AzorianSolutions/docker-knot-nameserver](https://github.com/AzorianSolutions/docker-knot-nameserver)
- **Website:** [https://azorian.solutions](https://azorian.solutions)

## TL;DR

    docker run -d -p 12053:53/udp -p 12053:53 azoriansolutions/knot-nameserver:debian

## Azorian Solutions Docker image strategy

The goal of creating this image and others alike is to provide a fairly uniform and turn-key implementation for a chosen set of products and solutions. By compiling the server binaries from source code, a greater chain of security is maintained by eliminating unnecessary trusts. This approach also helps assure support of specific features that may otherwise vary from distribution to distribution. A secondary goal of creating this image and others alike is to provide at least two Linux distribution options for any supported product or solution which is why you will often see tags for both Alpine Linux and Debian Linux.

All documentation will be written with the assumption that you are already reasonably familiar with this ecosystem. This includes container concepts, the Docker ecosystem, and more specifically the product or solution that you are deploying. Simply put, I won't be fluffing the docs with content explaining every detail of what is presented.

## Supported tags

### Alpine Linux

- 3.1.4, 3.1.4-alpine, 3.1.4-alpine-3.14, alpine, latest

### Debian Linux

- *3.1.4-debian, 3.1.4-debian-11.1-slim, debian

## Deploying this image

### Server configuration

Configuration of the Knot Nameserver may be achieved through the traditional configuration file approach.

[Know Nameserver Configuration Guide](https://www.knot-dns.cz/docs/3.1/html/configuration.html)

With this approach, you may create a traditional Knot Nameserver conf file and map it to the "/etc/knot/knot.conf" location inside of the container. For example, say you have an Knot Nameserver conf file located on your container host at "/srv/knot-nameserver.conf" then the proper mapping would be as follows;

    /srv/knot-nameserver.conf:/etc/knot/knot.conf

### Deploy with Docker Run

To run a simple container on Docker with this image, execute the following Docker command;

    docker run -d -p 12053:53/udp -p 12053:53 azoriansolutions/knot-nameserver:debian

If all goes well and the container starts, you should now be able to query this DNS recursor using dig;

    dig -p 12053 @IP-OR-HOSTNAME-OF-DOCKER-HOST a docker.com

### Deploy with Docker Compose

To run this image using Docker Compose, create a YAML file with a name and place of your choosing and add the following contents to it;

    version: "3.3"
    services:
      recursor:
        image: azoriansolutions/knot-nameserver:debian
        restart: unless-stopped
        ports:
          - "12053:53/udp"
          - "12053:53"
        volumes:
          - "/path/to/knot/conf/file.conf:/etc/knot/knot.conf"

Then execute the following Docker Compose command;

    docker-compose -u /path/to/yaml/file.yml

## Building this image

If you want to build this image yourself, you can easily do so using the **build-release** command I have included.

The build-release command has the following parameter format;

    build-release IMAGE_TAG_NAME KNOT_VERSION DISTRO_REPO_NAME DISTRO_TAG

So for example, to build the Knot Nameserver version 3.1.2 on Debian Linux 11.1-slim, you would execute the following shell command:

    build-release 3.1.2-debian-11.1-slim 3.1.2 debian 11.1-slim

The build-realease command assumes the following parameter defaults;

- Image Tag Name: latest
- Knot Version: 3.1.4
- Distro Name: debian
- Distro Tag: 11.1-slim

This means that running the build-release command with no parameters would be the equivalent of executing the following shell command:

    build-release latest 3.1.4 debian 11.1-slim

When the image is tagged during compilation, the repository portion of the image tag is derived from the contents of the .as/docker-registry file and the tag from the first parameter provided to the build-release command.

