#!/usr/bin/env bash
#
# Dynamically download, compile, and install the latest Python version.
# Usage: ./setup.python.sh <requirements.txt>
set -xe

REQUIREMENTS=$1

# Define Python version
PYTHON_VERSION="3.11.2" # Update this to the latest version you need

# Prepare build environment
apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    libffi-dev \
    uuid-dev \
    wget

# Download Python
cd /tmp
wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz

# Extract and compile Python
tar -xzf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
./configure --enable-optimizations
make -j 8  # Adjust '-j 8' based on the number of cores you want to use for the build
make altinstall  # Use altinstall to prevent overriding the system python binary

# Update alternatives (Optional, makes this Python version the default when calling python3)
update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python${PYTHON_VERSION:0:4} 1
update-alternatives --set python3 /usr/local/bin/python${PYTHON_VERSION:0:4}

# Install pip
python3 -m ensurepip
python3 -m pip install --no-cache-dir --upgrade pip

# Install required Python packages from requirements.txt
if [[ -f "$REQUIREMENTS" ]]; then
    python3 -m pip install --no-cache-dir -r $REQUIREMENTS
fi

echo "Python $PYTHON_VERSION installation completed."
