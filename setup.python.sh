#
# setup.python.sh: Install a specific Python version and packages for it.
# Usage: setup.python.sh <pyversion> <requirements.txt>
set -xe

source ~/.bashrc
VERSION=$1
REQUIREMENTS=$2

# Install Python packages for this container's version
cat >pythons.txt <<EOF
$VERSION
$VERSION-venv
$VERSION-distutils
$VERSION-dev
EOF
/setup.packages.sh pythons.txt

# Setup links for TensorFlow to compile.
# Referenced in devel.usertools/*.bazelrc
ln -sf /usr/bin/$VERSION /usr/bin/python3
ln -sf /usr/bin/$VERSION /usr/bin/python

# Python 3.10 include headers fix:
# sysconfig.get_path('include') incorrectly points to /usr/local/include/python
# map /usr/include/python3.10 to /usr/local/include/python3.10
if [[ ! -f "/usr/local/include/$VERSION" ]]; then
  ln -sf /usr/include/$VERSION /usr/local/include/$VERSION
fi

# Install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
python3 -m pip install --no-cache-dir --upgrade pip

# Disable the cache dir to save image space, and install packages
python3 -m pip install --no-cache-dir -r $REQUIREMENTS -U