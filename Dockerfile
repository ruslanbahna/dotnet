FROM ubuntu:latest

# Install Node.js v20 with minimal additional packages and clean up in one step
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get remove -y curl gnupg2 && \ 
    apt-get autoremove -y && \  
    apt-get clean && \  
    rm -rf /var/lib/apt/lists/* 

# Verify Node.js and npm installations
RUN node -v && npm -v











