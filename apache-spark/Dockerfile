FROM ubuntu:latest

# Using ARG for versions allows easier updates and more readable Dockerfiles
ARG JAVA_VERSION=openjdk-21-jdk
ARG SPARK_VERSION=3.5.0
ARG HADOOP_VERSION=3
ARG SCALA_VERSION=2.13
ARG SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${SCALA_VERSION}

# Set frontend to noninteractive to bypass prompts during build
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 \
    SPARK_HOME=${SPARK_HOME}

# Installing Java and utilities, then cleaning up in a single RUN to reduce layer size
RUN \
    --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get install --no-install-recommends --quiet -y ${JAVA_VERSION} wget tar tree && \
    wget -q https://www.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${SCALA_VERSION}.tgz -O /tmp/spark.tgz && \
    tar -xzf /tmp/spark.tgz -C /opt && \
    rm /tmp/spark.tgz && \
    apt-get upgrade -y && \
    apt-get purge -y wget tar && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Setting the working directory to SPARK_HOME
WORKDIR ${SPARK_HOME}