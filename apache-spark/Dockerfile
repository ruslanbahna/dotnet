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

# Update vulnerable JAR files
RUN wget -q -O $SPARK_HOME/jars/jackson-databind-2.12.7.1.jar https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.12.7.1/jackson-databind-2.12.7.1.jar && \
    rm $SPARK_HOME/jars/jackson-databind-2.12.7.jar && \
    wget -q -O $SPARK_HOME/jars/gson-2.8.9.jar https://repo1.maven.org/maven2/com/google/code/gson/gson/2.8.9/gson-2.8.9.jar && \
    rm $SPARK_HOME/jars/gson-2.2.4.jar

# Expose port for Spark Web UI
EXPOSE 8080

# Set working directory and default command
WORKDIR /opt/spark-3.5.0-bin-hadoop3-scala2.13
CMD ["/bin/bash"]
