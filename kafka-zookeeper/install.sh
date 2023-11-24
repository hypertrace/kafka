#!/bin/sh
# install script used only in building the docker image, but not at runtime.
# This uses relative path so that you can change the home dir without editing this file.
# This also trims dependencies to only those used at runtime.
set -eux

echo "*** Installing Kafka and dependencies"

# Download scripts and config for Kafka and ZooKeeper, but not for Connect
wget -qO- https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | tar xz \
  --wildcards --strip=1 --exclude=connect* */bin/zookeeper-* */bin/kafka-* */config

# Remove bash as our images don't have it, and it isn't required
sed -i 's~#!/bin/bash~#!/bin/sh~g' bin/*sh
# Remove bash syntax relating to irrelevant CYGWIN (prevents console errors)
sed -i -e 's/$(uname -a) =~ "CYGWIN"/0/g' -e  's/.*\(\( CYGWIN \)\).*//g' bin/*
# Remove bash shopt commands (kafka-start-class uses nullglob, but it is non-critical to avoid it)
sed -i 's/.*shopt.*//g' bin/*sh

# Hush logging for both Kafka and ZooKeeper
sed -i 's~INFO~WARN~g' config/log4j.properties

# Make sure you use relative paths in references like this, so that installation
# is decoupled from runtime
mkdir -p data/kafka data/zookeeper logs

# Set explicit, basic configuration
cat > config/zookeeper.properties <<-'EOF'
dataDir=./data/zookeeper
clientPort=2181
maxClientCnxns=0
admin.enableServer=false
# allow ruok command for testing ZK health
4lw.commands.whitelist=srvr,ruok
EOF

cat > config/server.properties <<-'EOF'
broker.id=0
zookeeper.connect=127.0.0.1:2181
replica.socket.timeout.ms=1500
# log.dirs is about Kafka's data not Log4J
log.dirs=./data/kafka
auto.create.topics.enable=true
offsets.topic.replication.factor=1
listeners=PLAINTEXT://0.0.0.0:9092,PLAINTEXT_HOST://0.0.0.0:19092
listener.security.protocol.map=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
EOF

# Dist includes large dependencies needed by streams and connect: retain only broker and ZK.
# We can do this because broker is independent from both kafka-streams and connect modules.
# See KAFKA-10380
#
# TODO: MDEP-723 if addressed can remove the pom.xml here
cat > pom.xml <<-'EOF'
<project>
  <modelVersion>4.0.0</modelVersion>

  <groupId>org.hypertrace.kafka</groupId>
  <artifactId>get-kafka</artifactId>
  <version>0.1.0-SNAPSHOT</version>
  <packaging>pom</packaging>

  <dependencies>
    <dependency>
      <groupId>org.apache.kafka</groupId>
      <artifactId>kafka_${SCALA_VERSION}</artifactId>
      <version>${KAFKA_VERSION}</version>
    </dependency>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-log4j12</artifactId>
      <version>1.7.36</version>
    </dependency>
    <dependency>
      <groupId>org.apache.zookeeper</groupId>
      <artifactId>zookeeper</artifactId>
      <version>3.8.3</version>
    </dependency>
    <dependency>
      <groupId>org.apache.zookeeper</groupId>
      <artifactId>zookeeper-jute</artifactId>
      <version>3.8.3</version>
    </dependency>
  </dependencies>
</project>
EOF
mvn -q --batch-mode dependency:copy-dependencies -DoutputDirectory=libs && rm pom.xml

echo "*** Image build complete"
