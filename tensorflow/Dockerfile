FROM tensorflow/tensorflow:latest

# Install Java and other necessary utilities
RUN apt-get update && \
    apt-get install -y apt-utils && \
    # Upgrade all installed packages to their latest versions
    apt-get upgrade -y && \
    # Explicitly update Python to the latest 3.11 patch version and linux-libc-dev
    apt-get install -y python3.11 python3.11-dev python3.11-venv linux-libc-dev --only-upgrade && \
    # Clean up cache data and unnecessary packages
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
