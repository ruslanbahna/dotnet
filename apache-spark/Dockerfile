# Use the latest Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables
ENV JAVA_HOME=/opt/java/openjdk \
    SPARK_HOME=/opt/spark \
    PATH=$JAVA_HOME/bin:$PATH \
    SPARK_VERSION=3.5.0 \
    HADOOP_VERSION=3.2 \
    SPARK_TGZ_URL=https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

# Install necessary packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    tar \
    openjdk-11-jdk \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME in a way that is recognized by bash
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile.d/java.sh

# Download and install Apache Spark
RUN wget --no-verbose -O /tmp/spark.tgz "$SPARK_TGZ_URL" \
    && mkdir -p "$SPARK_HOME" \
    && tar -xzf /tmp/spark.tgz -C /tmp \
    && mv /tmp/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION/* "$SPARK_HOME" \
    && rm /tmp/spark.tgz

# Set working directory
WORKDIR $SPARK_HOME

# Expose ports (4040: Spark UI, 7077: Master, 8080: Worker)
EXPOSE 4040 7077 8080

# Define default command
CMD ["/bin/bash"]
