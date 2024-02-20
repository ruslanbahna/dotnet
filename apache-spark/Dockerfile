FROM ubuntu:latest

# Install Java
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk wget tar && \
    apt-get clean;

# Set Java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Download and install Spark
RUN wget -q https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3-scala2.13.tgz && \
    tar -xzf spark-3.5.0-bin-hadoop3-scala2.13.tgz -C /opt && \
    rm spark-3.5.0-bin-hadoop3-scala2.13.tgz
RUN wget -q -O /opt/spark-3.5.0-bin-hadoop3-scala2.13/jars/jackson-databind-2.16.1.jar \
    https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.16.1/jackson-databind-2.16.1.jar
RUN wget -q -O /opt/spark-3.5.0-bin-hadoop3-scala2.13/jars/jackson-annotations-2.16.1.jar \
    https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.16.1/jackson-annotations-2.16.1.jar
RUN wget -q -O /opt/spark-3.5.0-bin-hadoop3-scala2.13/jars/jjackson-core-2.16.1.jar \
    https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.16.1/jackson-core-2.16.1.jar

# Set Spark environment variable
ENV SPARK_HOME /opt/spark-3.5.0-bin-hadoop3-scala2.13

# Expose port for Spark Web UI
EXPOSE 8080

# Set working directory and default command
WORKDIR /opt/sspark-3.5.0-bin-hadoop3-scala2.13
CMD ["/bin/bash"]



# https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.16.1/jackson-dataformat-yaml-2.15.2.jar
# https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.16.1/jackson-datatype-jsr310-2.15.2.jar