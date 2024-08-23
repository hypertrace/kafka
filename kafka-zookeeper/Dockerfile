# This Dockerfile and supporting content derived originally from
# https://github.com/openzipkin/zipkin/blob/master/docker/collector/kafka/

# Using the same image as we use in CircleCI to avoid transfer costs
FROM cimg/openjdk:14.0.2 AS install

# Use latest stable release here. Scala 2.13+ supports JRE 14
ENV KAFKA_VERSION=3.7.1 SCALA_VERSION=2.13

USER root
WORKDIR /install
COPY install.sh /tmp/
RUN /tmp/install.sh && rm /tmp/install.sh

# Share the same base image to reduce layers used in testing
FROM hypertrace/java:11
LABEL MAINTAINER Hypertrace "https://www.hypertrace.org/"

# Add HEALTHCHECK and ENTRYPOINT scripts into the default search path
COPY docker-bin/* /usr/local/bin/

# All content including binaries and logs write under WORKDIR
WORKDIR /opt/kafka
ARG USER=kafka

# Ensure the process doesn't run as root
RUN adduser -g '' -h ${PWD} -D ${USER}
USER ${USER}

# Copy binaries and config we installed earlier
COPY --from=install --chown=${USER} /install .

# ${KAFKA_ADVERTISED_HOST_NAME}:19092 is for connections from the Docker host
ENV KAFKA_ADVERTISED_HOST_NAME=localhost
EXPOSE 2181 9092 19092

# We use start period of 30s to avoid marking the container unhealthy on slow or contended CI hosts
HEALTHCHECK --interval=1s --start-period=30s --timeout=5s CMD ["docker-healthcheck"]

ENTRYPOINT ["start-kafka-zookeeper"]
