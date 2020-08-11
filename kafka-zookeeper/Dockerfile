FROM alpine:3.12 AS kafka

ENV SCALA_VERSION 2.12
ENV KAFKA_VERSION 2.3.0

WORKDIR /opt/kafka
COPY install.sh /opt/kafka/install
RUN /opt/kafka/install && rm /opt/kafka/install

COPY wait-for-zookeeper.sh /opt/kafka/bin
COPY start.sh /opt/kafka/bin

# Share the same base image to reduce layers
FROM hypertrace/java:11

MAINTAINER Hypertrace "https://www.hypertrace.org/"

WORKDIR /opt/kafka

RUN adduser -g '' -h /opt/kafka -D kafka

COPY --from=kafka --chown=kafka /opt/kafka /opt/kafka

USER kafka

# Port 19092 is for connections from the Docker host
EXPOSE 2181 9092 19092

# We use start period of 10s to avoid marking Kafka unhealthy on slow or contended CI hosts
#
# We use a timeout of 5s as kafka-topics.sh invokes a Java command which can be slow when
# multiple processes are starting up (ex docker-compose with >10 containers). A smaller timeout
# flips the service unhealthy and can interfere with docker-compose v2 condition: service_healthy
HEALTHCHECK --interval=2s --start-period=10s --timeout=5s \
  # We use bootstrap-server, not zookeeper, as KIP-500 will eventually remove the dependency
  CMD /opt/kafka/bin/kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --list > /dev/null || exit 1

ENTRYPOINT /opt/kafka/bin/start.sh
