FROM ubuntu:latest

# Install Node.js v20 with minimal additional packages and clean up in one step
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get remove -y curl gnupg2 && \  # Remove packages used for setup
    apt-get autoremove -y && \  # Automatically remove all unused packages
    apt-get clean && \  # Clean up the apt cache
    rm -rf /var/lib/apt/lists/*  # Remove apt list files

# Verify Node.js and npm installations
RUN node -v && npm -v











