# Base image
FROM ubuntu:20.04 as builder

# Install dependencies for fetching and verifying Spark
RUN apt-get update && \
    apt-get install -y gnupg2 wget bash tini libc6 libpam-modules krb5-user libnss3 procps net-tools gosu libnss-wrapper && \
    rm -rf /var/lib/apt/lists/*

# Set up environment variables for Java and Spark
ENV JAVA_HOME=/opt/java/openjdk \
    PATH=$JAVA_HOME/bin:$PATH \
    SPARK_HOME=/opt/spark \
    SPARK_VERSION=3.5.0 \
    HADOOP_VERSION=3.2 \
    SPARK_TGZ_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    SPARK_TGZ_ASC_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz.asc \
    GPG_KEY=FC3AE3A7EAA1BAC98770840E7E1ABCC53AAA2216

# Download and verify Spark
RUN set -ex && \
    wget -nv -O spark.tgz "$SPARK_TGZ_URL" && \
    wget -nv -O spark.tgz.asc "$SPARK_TGZ_ASC_URL" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-key "$GPG_KEY" && \
    gpg --batch --verify spark.tgz.asc spark.tgz && \
    gpgconf --kill all && \
    rm -rf "$GNUPGHOME" spark.tgz.asc

# Extract Spark to the installation directory
RUN tar -xf spark.tgz --strip-components=1 -C $SPARK_HOME && \
    rm spark.tgz

# Set up Spark user
ARG spark_uid=185
RUN groupadd --system --gid=${spark_uid} spark && \
    useradd --system --uid=${spark_uid} --gid=spark spark

# Switch to Spark user
USER spark

# Set the working directory
WORKDIR $SPARK_HOME/work-dir

# Copy entrypoint script (assumed to be customized for this build)
COPY entrypoint.sh /opt/

# Set entrypoint
ENTRYPOINT ["/opt/entrypoint.sh"]

# Switch back to root to install Python (the inspect output suggests this was done later)
USER root
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Switch back to Spark user
USER spark
