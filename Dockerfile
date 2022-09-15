# TODO: port this similarly to kafka-zookeeper in order to share base layer
# The only assumption we make about this FROM is that it has a JRE in path
FROM adoptopenjdk/openjdk11:jre-11.0.4_11@sha256:140ba182d696180600a2871a98f67ad0ee2d6a1e48a7c570d1c0e156860c2a9d

# Use latest stable release here. Scala 2.13+ supports JRE 14
ENV KAFKA_VERSION=3.2.1 SCALA_VERSION=2.13

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='netcat-openbsd'; \
  buildDeps='curl ca-certificates gnupg dirmngr'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  curl -s -L -o KEYS https://www.apache.org/dist/kafka/KEYS; \
  gpg --import KEYS && rm KEYS; \
  \
  SCALA_BINARY_VERSION=$(echo $SCALA_VERSION | cut -f 1-2 -d '.'); \
  mkdir -p /opt/kafka; \
  chmod a+w /opt/kafka; \
  curl -s -L  -o kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz.asc https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz.asc; \
  curl -SLs -o kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz "https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz"; \
  gpg --verify kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz.asc kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz; \
  tar xzf kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz --strip-components=1 -C /opt/kafka; \
  rm kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz; \
  \
  rm -rf /opt/kafka/site-docs; \
  \
  mkdir -p /opt/kafka/prometheus; \
  curl -s -o /opt/kafka/prometheus/jmx_prometheus_javaagent-0.12.0.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.12.0/jmx_prometheus_javaagent-0.12.0.jar; \
  curl -s -o /opt/kafka/prometheus/kafka-2_0_0.yml https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/kafka-2_0_0.yml; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /etc/ssl/certs /root/.gnupg

WORKDIR /opt/kafka

COPY docker-help.sh /usr/local/bin/docker-help
ENTRYPOINT ["docker-help"]
