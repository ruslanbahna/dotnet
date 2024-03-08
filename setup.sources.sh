#
# setup.python.sh: Install a specific Python version and packages for it.
# Usage: setup.python.sh <pyversion> <requirements.txt>

# Sets up custom apt sources for our TF images.

# Prevent apt install tzinfo from asking our location (assumes UTC)
export DEBIAN_FRONTEND=noninteractive

# Set up shared custom sources
apt-get update
apt-get install -y gnupg ca-certificates wget

# Install Nvidia repo keys
# See: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#network-repo-installation-for-ubuntu
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb