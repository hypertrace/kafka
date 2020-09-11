# Kafka
Apache Kafka is a highly scalable, fast, fault-tolerant and open-source distributed event streaming platform, which needs no introduction. 

This repo publishes the docker image and helm chart for [Apache Kafka](https://kafka.apache.org/).

## Description
Hypertrace leverages Kafka for streaming the distributed trace data so that the platform can scale horizontally. All the components in the Hypertrace ingest pipeline read the data from and write back to Kafka topics. These components are horizontally scalable by running more replicas and also increasing the partitions for the Kafka topic.

| ![space-1.jpg]( https://hypertrace-docs.s3.amazonaws.com/ingestion-pipeline.png) | 
|:--:| 
| *Hypertrace Ingestion Pipeline* |

Hypertrace works with stock Kafka so any Kafka Docker image can be used or you can reuse your existing Kafka deployments.
This repo is mainly to optimize the Kafka Docker image size, unify the image along with other Hypertrace Docker images, and have helm charts to easily deploy, scale and manage Kafka easily in Kubernetes. 


## Building Locally
To build kafka image locally, run:

```
./gradlew dockerBuildImages
```

`Note:` 
- docker-compose uses `kafka-zookeeper` image so you have to build it from that folder in case you are working on that one. 
- To read more about installing and configuring helm chart refer [BUILD.md](/BUILD.md).

## Testing

You can test the image you built after modification by running docker-compose or helm setup. 

### docker-compose
Change the tag for `kafka-zookeeper` from `:main` to `:test` in [docker-compose file](https://github.com/hypertrace/hypertrace/blob/main/docker/docker-compose.yml) like this.

```yaml
  kafka-zookeeper:
    image: hypertrace/kafka-zookeeper:test
    container_name: kafka-zookeeper
    ...
```

and then run `docker-compose up` to test the setup.

## Docker Image Source:
- [DockerHub > kafka](https://hub.docker.com/r/hypertrace/kafka)
- [DockerHub > kafka-zookeeper](https://hub.docker.com/r/hypertrace/kafka-zookeeper)
