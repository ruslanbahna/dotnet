FROM ubuntu:latest

# Install required packages with --no-install-recommends, setup Node.js, install Node.js, Yarn, and update npm in one RUN command
# then remove unnecessary packages and clean up in the same RUN command to minimize the layer size
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g yarn npm@10.4.0 && \
    apt-get remove --purge -y curl gnupg2 && apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*













