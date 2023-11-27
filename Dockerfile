FROM adoptopenjdk/openjdk11:jre-11.0.21_9@sha256:adbfa4e7aee9bd8d39424b018cb9835261929622d0b169b26b10c2e04fa6b8ff

# Use latest stable release here. Scala 2.13+ supports JRE 14
ENV KAFKA_VERSION=3.6.0 SCALA_VERSION=2.13

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='netcat-openbsd'; \
  buildDeps='curl ca-certificates gnupg dirmngr'; \
  apt-get update && apt-get upgrade -y && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
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
  rm /opt/kafka/libs/zookeeper-3.8.2.jar /opt/kafka/libs/zookeeper-jute-3.8.2.jar; \
  curl -SLs -o /opt/kafka/libs/zookeeper-3.8.2.jar https://repo1.maven.org/maven2/org/apache/zookeeper/zookeeper/3.8.3/zookeeper-3.8.3.jar; \
  curl -SLs -o /opt/kafka/libs/zookeeper-jute-3.8.2.jar https://repo1.maven.org/maven2/org/apache/zookeeper/zookeeper-jute/3.8.3/zookeeper-jute-3.8.3.jar; \
  rm kafka_$SCALA_BINARY_VERSION-$KAFKA_VERSION.tgz; \
  \
  rm -rf /opt/kafka/site-docs; \
  \
  apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /etc/ssl/certs /root/.gnupg

WORKDIR /opt/kafka

COPY docker-help.sh /usr/local/bin/docker-help
ENTRYPOINT ["docker-help"]
