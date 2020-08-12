#!/bin/sh

set -eux

echo "*** Installing Kafka and dependencies"
apk add --update --no-cache jq curl

APACHE_MIRROR=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred')

# download kafka binaries
curl -sSL $APACHE_MIRROR/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | tar xz
mv kafka_$SCALA_VERSION-$KAFKA_VERSION/* .

# Remove bash as our images doesn't have it, and it isn't required
sed -i 's~#!/bin/bash~#!/bin/sh~g' /opt/kafka/bin/*sh

# Set explicit, basic configuration
cat > config/server.properties <<-EOF
broker.id=0
zookeeper.connect=127.0.0.1:2181
replica.socket.timeout.ms=1500
log.dirs=/opt/kafka/data
auto.create.topics.enable=true
offsets.topic.replication.factor=1
listeners=PLAINTEXT://0.0.0.0:9092,PLAINTEXT_HOST://0.0.0.0:19092
listener.security.protocol.map=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
EOF

mkdir /opt/kafka/data

echo "*** Cleaning Up"
apk del jq curl --purge
# TODO: eventually cleanup irrelevant binaries from RocksDB
# https://issues.apache.org/jira/browse/KAFKA-10380
rm -rf kafka_$SCALA_VERSION-$KAFKA_VERSION site-docs bin/windows

echo "*** Image build complete"
