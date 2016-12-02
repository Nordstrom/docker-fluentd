# docker-fluentd

docker-fluentd collects container logs and systemd journal logs.

Included plugins:

1. `fluent-plugin-systemd`: reads logs from systemd journal
1. `fluent-plugin-kubernetes_metadata_filter`: enriches container logs with kubernetes metadata
1. `fluent-plugin-elasticsearch`: outputs to Elasticsearch
1. `fluent-plugin-aws-elasticsearch-service`: outputs to AWS-ES service (request signing, etc)

In order to enable above logs collection, mount the following paths as volumes:

* `/var/log `
* `/var/lib/docker/containers`

Refer the following links for reference:

* [docker-fluentd-kubernetes](https://github.com/fabric8io/docker-fluentd-kubernetes)
* [fluent-plugin-kubernetes_metadata_filter](https://github.com/fabric8io/fluent-plugin-kubernetes_metadata_filter) 
* [fluent-plugin-aws-elasticsearch-service](https://github.com/atomita/fluent-plugin-aws-elasticsearch-service)
* [fluent-plugin-systemd](https://github.com/reevoo/fluent-plugin-systemd)
