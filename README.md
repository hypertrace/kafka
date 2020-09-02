# Kafka
Apache Kafka is a highly scalable, fast, and fault-tolerant distributed streaming platform. 

This repo publishes the docker image and helm chart for [Apache Kafka](https://kafka.apache.org/).

## How do we use kafka?
Kafka forms the core of the Hypertrace streaming platform and being used extensively across the services. Kafka usage at Hypertrace can be categorised into 3 categories: Plain vanilla Kafka Clients, Kafka streams and Streaming pipeline jobs. We are migrating streaming pipeline jobs also to Kafka streams.
We use Confluent Avro schema-registry as a serialization mechanism for the messages published to Kafka and these Schemas are defined in the code along with their respective owner modules.

| ![space-1.jpg]( https://hypertrace-docs.s3.amazonaws.com/ingestion-pipeline.png) | 
|:--:| 
| *Hypertrace Ingestion Pipeline* |


## Prerequisites
* Kubernetes 1.10+
* Helm 3.0+

## Docker Image
The docker image is published to [Docker Hub](https://hub.docker.com/r/hypertrace/kafka)

## Helm Chart Components
This chart will do the following:

* Create a fixed size Kafka cluster using a [StatefulSet](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/).
* Create a [PodDisruptionBudget](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-disruption-budget/).
* Create a [Headless Service](https://kubernetes.io/docs/concepts/services-networking/service/) to control the domain of the Kafka cluster.
* Create a Service configured to connect to the available Kafka instance on the configured client port.
* Optionally apply a [Pod Anti-Affinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#inter-pod-affinity-and-anti-affinity-beta-feature) to spread the Kafka cluster across nodes.
* Optionally start a JMX Exporter container inside Kafka pods.
* Optionally create a Prometheus ServiceMonitor for each enabled jmx exporter container.
* Optionally add prometheus alerts.
* Optionally create a new storage class.

## Installing the Chart
You can install the chart with the release name `kafka` as below.

```console
$ helm upgrade kafka ./helm --install --namespace hypertrace
```

## Configuration
You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm upgrade my-release ./helm --install --namespace hypertrace -f values.yaml
```

## Default Values
- You can find all user-configurable settings, their defaults in [values.yaml](helm/values.yaml).
