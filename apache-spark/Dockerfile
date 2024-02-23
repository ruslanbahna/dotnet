FROM ubuntu:latest

# Install Java
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk wget tar && \
    apt-get clean;

# Set Java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

# Download and install Spark
RUN wget -q https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3-scala2.13.tgz && \
    tar -xzf spark-3.5.0-bin-hadoop3-scala2.13.tgz -C /opt && \
    rm spark-3.5.0-bin-hadoop3-scala2.13.tgz

# Set Spark environment variable
ENV SPARK_HOME /opt/spark-3.5.0-bin-hadoop3-scala2.13

# Expose port for Spark Web UI
EXPOSE 8080

# Set working directory and default command
WORKDIR /opt/spark-3.5.0-bin-hadoop3-scala2.13
CMD ["/bin/bash"]
