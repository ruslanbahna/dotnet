FROM ubuntu:latest

# Install curl, add NodeSource repository for Node.js v20, install Node.js, 
# install Yarn globally, update npm to version 10.4.0, and clean up in one RUN command
RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn npm@10.4.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*













