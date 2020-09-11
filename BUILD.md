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
