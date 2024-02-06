# Use the latest version of Ubuntu as the base image
FROM ubuntu:latest

# Install curl and other necessary dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add NodeSource repository for Node.js v20 and install Node.js
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Yarn globally using npm
RUN npm install -g yarn

# Update npm to version 10.4.0
RUN npm install -g npm@10.4.0













