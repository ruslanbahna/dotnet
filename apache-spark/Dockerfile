
FROM ubuntu:latest
RUN \
    --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update ; \
    apt-get --no-install-recommends --quiet install -o=Dkpg::Use-Pty=0 -y openjdk-21-jdk wget tar tree ;
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
RUN \
    wget -q https://www.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3-scala2.13.tgz ; \
    tar -xzf spark-3.5.0-bin-hadoop3-scala2.13.tgz -C /opt ;
    rm spark-3.5.0-bin-hadoop3-scala2.13.tgz ; \
    apt-get update ; \
    apt-get --no-install-recommends --quiet -o=Dkpg::Use-Pty=0 --yes upgrade ; \
    apt-get purge --yes wget tar ; \
    apt --yes autoremove ; \
    rm -rf /var/lib/lists/* ;
ENV SPARK_HOME /opt/spark-3.5.0-bin-hadoop3-scala2.13
WORKDIR /opt/spark-3.5.0-bin-hadoop3-scala2.13