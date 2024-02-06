FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify Node.js and npm installations
RUN node -v && npm -v












