FROM ubuntu:latest

# Install Java
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk  wget && \
    apt-get clean;

# Set Java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Install wget and download Spark
RUN apt-get -y install wget && \
    wget -q https://dlcdn.apache.org/spark/spark-3.4.2/spark-3.4.2-bin-hadoop3.tgz

# Unpack Spark
RUN tar -xzf spark-3.4.2-bin-hadoop3.2.tgz && \
    mv spark-3.4.2-bin-hadoop3.2 /spark

# Set Spark environment variable
ENV SPARK_HOME /spark

# Expose port 8080 for Spark Web UI
EXPOSE 8080

# Start Spark shell (or any other Spark component you need)
CMD ["/spark/bin/spark-shell"]