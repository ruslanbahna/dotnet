# Base image
FROM spark:latest

# Install dependencies for fetching and verifying Spark
RUN apt-get update && \
    apt-get install -y gnupg2 wget bash tini libc6 libpam-modules krb5-user libnss3 procps net-tools gosu libnss-wrapper && \
    rm -rf /var/lib/apt/lists/*
