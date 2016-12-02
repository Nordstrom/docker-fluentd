FROM quay.io/nordstrom/baseimage-ubuntu:16.04
MAINTAINER Enterprise Kubernetes Platform Team "techk8s@nordstrom.com"

USER root 

# Ensure there are enough file descriptors for running Fluentd.
RUN ulimit -n 65536

# Setup package for installing td-agent. (For more info https://td-toolbelt.herokuapp.com/sh/install-ubuntu-trusty-td-agent2.sh)
ADD GPG-KEY-td-agent /tmp/apt-key
RUN apt-key add /tmp/apt-key && \
    echo "deb http://packages.treasuredata.com/2/ubuntu/trusty/ trusty contrib" \
      > /etc/apt/sources.list.d/treasure-data.list

# Install prerequisites.
RUN apt-get update -qy && \
    apt-get install -qy \
      make \
      g++ \
      td-agent

# Change the default user and group to root.
# Needed to allow access to /var/log/docker/... files.
RUN sed -i -e "s/USER=td-agent/USER=root/" -e "s/GROUP=td-agent/GROUP=root/" /etc/init.d/td-agent

RUN /usr/sbin/td-agent-gem install --no-ri --no-rdoc -v 0.26.2 fluent-plugin-kubernetes_metadata_filter
# See: https://github.com/atomita/fluent-plugin-aws-elasticsearch-service
RUN /usr/sbin/td-agent-gem install --no-ri --no-rdoc -v 0.1.6 fluent-plugin-aws-elasticsearch-service
# See: https://github.com/uken/fluent-plugin-elasticsearch
# RUN /usr/sbin/td-agent-gem install --no-ri --no-rdoc -v 1.9.0 fluent-plugin-elasticsearch
# See: https://github.com/reevoo/fluent-plugin-systemd
RUN /usr/sbin/td-agent-gem install --no-ri --no-rdoc -v 0.0.5 fluent-plugin-systemd

# Copy the Fluentd configuration file.
COPY td-agent.conf /etc/td-agent/td-agent.conf
# COPY start-fluentd /start-fluentd
# RUN chmod 766 /etc/td-agent/td-agent.conf
# RUN chmod +x /start-fluentd

# Create directory for pos files and assign write permission to it
ENV POS_FILE_LOCATION /var/log
RUN mkdir -p ${POS_FILE_LOCATION} && \
    chmod 766 ${POS_FILE_LOCATION}

# Run the Fluentd service.
ENTRYPOINT ["/usr/sbin/td-agent"]
