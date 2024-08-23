FROM adoptopenjdk/openjdk11:jre-11.0.23_9@sha256:81358f8e62b311b539fe9c527f1f6c5b8322c42865fb29f7523f300b07f02185

# Use latest stable release here. Scala 2.13+ supports JRE 14
ENV KAFKA_VERSION=3.7.1 SCALA_VERSION=2.13

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
