FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get install -y npm && \
    apt-get remove -y curl gnupg2 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN node -v && npm -v











