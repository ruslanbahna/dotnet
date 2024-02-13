FROM ubuntu:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        wget \
        ca-certificates \
        python3 \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64 \
    SPARK_HOME /opt/spark

RUN wget --no-verbose https://dlcdn.apache.org/spark/spark-3.3.4/spark-3.3.4-bin-hadoop3.tgz \
    && tar -xzf spark-3.3.4-bin-hadoop3.tgz -C /opt \
    && mv /opt/spark-3.3.4-bin-hadoop3 $SPARK_HOME \
    && rm spark-3.3.4-bin-hadoop3.tgz

COPY app /opt/app

ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
WORKDIR $SPARK_HOME

CMD ["bin/spark-shell"]