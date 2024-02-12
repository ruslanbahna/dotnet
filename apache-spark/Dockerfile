# Base image
# Use the latest Ubuntu as the base image
FROM ubuntu:latest

# Install OpenJDK and other dependencies, avoiding unnecessary packages
# Install OpenJDK 17 and other dependencies, avoiding unnecessary packages
# Install OpenJDK 17 and other dependencies, avoiding unnecessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        wget \
        ca-certificates \
        python3 \
        python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Set the Java environment variable (adjust if necessary for OpenJDK 17)
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

# Define Spark version to install
ENV SPARK_VERSION=3.3.4 \
    SPARK_HOME=/opt/spark

# Download and unpack Apache Spark
RUN wget --no-verbose https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz && \
    tar -xzf spark-$SPARK_VERSION-bin-hadoop3.tgz -C /opt && \
    mv /opt/spark-$SPARK_VERSION-bin-hadoop3 $SPARK_HOME && \
    rm spark-$SPARK_VERSION-bin-hadoop3.tgz
# Update PATH environment variable
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Expose ports for Spark UI and other services
EXPOSE 4040 7077 8080 8081

# Set working directory
WORKDIR $SPARK_HOME

# Default command: start the Spark shell
CMD ["bin/spark-shell"]
