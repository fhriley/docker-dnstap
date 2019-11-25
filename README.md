# docker-dnstap

A Dockerized minimal [dnstap](https://dnstap.info/) application with supporting example using [CoreDNS's](https://coredns.io) [dnstap plugin](https://coredns.io/plugins/dnstap/) orchestrated using [docker-compose](https://docs.docker.com/compose/).

## Motivation

In order to log all of the DNS queries / responses without sniffing packets over the wire, a number of DNS Servers provide a hook to listen to these events and publish to a service called dnstap.  There are currently no minimal dnstap images which I could find and a way to demonstrate it working simply which I could find.

## Requirements

* Docker Engine >= 19.x
* Docker Compose >= 1.24.x
* Ability to configure system DNS

## Installation & Setup

$`docker-compose pull`

$`docker-compose up -d`

Point your dns service at `127.0.0.1` and view the logs for dns requests which will be routed to Cloudflare `1.1.1.1` and `1.0.0.1` over TLS.

The CoreDNS Corefile can be tweaked as part of the install and the usual docker-compose commands can be used to restart containers when changes have been made.

## Artifacts

The dnstap application image is published to Docker hub as [mattjtodd/dnstap](https://hub.docker.com/repository/docker/mattjtodd/dnstap).

It can easily be rebuilt locally should you need to test something by running
`docker-compose build`

## Notes

* The configuration for the CoreDNS dnstap plugin doesn't allow for a DNS name to be used for the tcp connection so the dnstap service shares the namespace of the CoreDNS service to allow this over the loopback interface, which is similar to how a pod works in Kubernetes (Side Car Pattern).  This is defined in the compose file using `network_mode: service:coredns` in the dnstap service block.

