plugins {
  id("base")
  id("org.hypertrace.docker-plugin") version "0.10.1"
  id("org.hypertrace.docker-publish-plugin") version "0.10.1"
}

hypertraceDocker {
  defaultImage {
    imageName.set("kafka")
  }
}
