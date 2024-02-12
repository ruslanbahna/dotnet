# Base image
# Use the latest Ubuntu as the base image
FROM ubuntu:latest

# Install OpenJDK and other dependencies, avoiding unnecessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        wget \
        ca-certificates \
        python3 \
        python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get upgrade
# Set the Java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Define Spark and Hadoop versions to install
ENV SPARK_VERSION=3.2.1 \
    HADOOP_VERSION=3.2 \
    SPARK_HOME=/opt/spark

# Download and unpack Apache Spark
RUN wget --no-verbose https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    tar -xzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C /opt && \
    mv /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME && \
    rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

# Update PATH environment variable
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Expose ports for Spark UI and other services
EXPOSE 4040 7077 8080 8081

# Set working directory
WORKDIR $SPARK_HOME

# Default command: start the Spark shell
CMD ["bin/spark-shell"]
