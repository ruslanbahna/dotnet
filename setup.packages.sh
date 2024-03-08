#!/usr/bin/env bash
# setup.packages.sh: Given a list of Ubuntu packages, install them and clean up.
# Usage: setup.packages.sh <package_list.txt>
set -e

# Prevent "apt install tzinfo" from raising an interactive location prompt
export DEBIAN_FRONTEND=noninteractive

apt-get update

# Remove commented lines and blank lines from the package list
apt-get install -y --no-install-recommends $(sed -e '/^\s*#.*$/d' -e '/^\s*$/d' "$1" | sort -u)

apt-get clean
rm -rf /var/lib/apt/lists/*