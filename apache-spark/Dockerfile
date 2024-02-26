# FROM ubuntu:latest

# # Install Java
# RUN apt-get update && \
#     apt-get install -y openjdk-17-jdk wget tar && \
#     apt-get clean;

# # Set Java environment variable
# ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

# # Download and install Spark
# RUN wget -q https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3-scala2.13.tgz && \
#     tar -xzf spark-3.5.0-bin-hadoop3-scala2.13.tgz -C /opt && \
#     rm spark-3.5.0-bin-hadoop3-scala2.13.tgz

# # Set Spark environment variable
# ENV SPARK_HOME /opt/spark-3.5.0-bin-hadoop3-scala2.13

# # Update vulnerable JAR files

# # Expose port for Spark Web UI
# EXPOSE 8080

# # Set working directory and default command
# WORKDIR /opt/spark-3.5.0-bin-hadoop3-scala2.13
# CMD ["/bin/bash"]

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM eclipse-temurin:17-jre-jammy

ARG spark_uid=185

RUN groupadd --system --gid=${spark_uid} spark && \
    useradd --system --uid=${spark_uid} --gid=spark spark

RUN set -ex; \
    apt-get update; \
    apt-get install -y gnupg2 wget bash tini libc6 libpam-modules krb5-user libnss3 procps net-tools gosu libnss-wrapper; \
    mkdir -p /opt/spark; \
    mkdir /opt/spark/python; \
    mkdir -p /opt/spark/examples; \
    mkdir -p /opt/spark/work-dir; \
    chmod g+w /opt/spark/work-dir; \
    touch /opt/spark/RELEASE; \
    chown -R spark:spark /opt/spark; \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su; \
    rm -rf /var/lib/apt/lists/*

# Install Apache Spark
# https://downloads.apache.org/spark/KEYS
ENV SPARK_TGZ_URL=https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz \
    SPARK_TGZ_ASC_URL=https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz.asc

RUN set -ex; \
    export SPARK_TMP="$(mktemp -d)"; \
    cd $SPARK_TMP; \
    wget -nv -O spark.tgz "$SPARK_TGZ_URL"; \
    wget -nv -O spark.tgz.asc "$SPARK_TGZ_ASC_URL"; \
    tar -xf spark.tgz --strip-components=1; \
    chown -R spark:spark .; \
    mv jars /opt/spark/; \
    mv bin /opt/spark/; \
    mv sbin /opt/spark/; \
    mv kubernetes/dockerfiles/spark/decom.sh /opt/; \
    mv examples /opt/spark/; \
    mv kubernetes/tests /opt/spark/; \
    mv data /opt/spark/; \
    mv python/pyspark /opt/spark/python/pyspark/; \
    mv python/lib /opt/spark/python/lib/; \
    mv R /opt/spark/; \
    chmod a+x /opt/decom.sh; \
    cd ..; \
    rm -rf "$SPARK_TMP";

# Copy the entrypoint script into the image
COPY ./entrypoint.sh /opt/

# Set the correct permissions for the entrypoint script
RUN chmod +x /opt/entrypoint.sh

# Set the SPARK_HOME environment variable
ENV SPARK_HOME /opt/spark

# Set the working directory to the Spark work directory
WORKDIR /opt/spark/work-dir

# Set the user to 'spark'
USER spark

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/opt/entrypoint.sh"]