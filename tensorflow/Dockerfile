# FROM tensorflow/tensorflow:latest

# # Install Java and other necessary utilities
# RUN apt-get update && \
#     apt-get install -y apt-utils && \
#     # Upgrade all installed packages to their latest versions
#     apt-get upgrade -y && \
#     # Explicitly update Python to the latest 3.11 patch version and linux-libc-dev
#     apt-get install -y python3.11 python3.11-dev python3.11-venv linux-libc-dev --only-upgrade && \
#     # Clean up cache data and unnecessary packages
#     apt-get clean && \
#     apt-get autoremove -y && \
#     rm -rf /var/lib/apt/lists/*
# Use an official Python runtime as a parent image, specifying the version that aligns with TensorFlow's requirements
# Use the latest Ubuntu image as the base
# FROM ubuntu:22.04 as base
# ENV DEBIAN_FRONTEND=noninteractive
# ENV LANG C.UTF-8

# COPY ./setup.sources.sh /setup.sources.sh
# COPY ./setup.packages.sh /setup.packages.sh
# COPY ./cpu.packages.txt /cpu.packages.txt
# RUN chmod +x /setup.sources.sh /setup.packages.sh
# RUN /setup.sources.sh 
# RUN /setup.packages.sh /cpu.packages.txt


# ARG PYTHON_VERSION=python3.11
# ARG TENSORFLOW_PACKAGE=tensorflow-cpu
# COPY ./setup.python.sh /setup.python.sh
# COPY ./cpu.requirements.txt /cpu.requirements.txt
# RUN chmod +x /setup.python.sh
# RUN /setup.python.sh $PYTHON_VERSION /cpu.requirements.txt
# RUN pip install --no-cache-dir ${TENSORFLOW_PACKAGE} 

# COPY bashrc /etc/bash.bashrc
# RUN chmod a+rwx /etc/bash.bashrc

# Use multi-stage build to reduce the size of the final image
# Stage 1: Build environment
FROM ubuntu:22.04 as base
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8

COPY ./setup.sources.sh /setup.sources.sh
COPY ./setup.packages.sh /setup.packages.sh
COPY ./cpu.packages.txt /cpu.packages.txt
RUN chmod +x /setup.sources.sh /setup.packages.sh
RUN /setup.sources.sh 
RUN /setup.packages.sh /cpu.packages.txt


ARG PYTHON_VERSION=python3.11
ARG TENSORFLOW_PACKAGE=tensorflow-cpu
COPY ./setup.python.sh /setup.python.sh
COPY ./cpu.requirements.txt /cpu.requirements.txt
RUN chmod +x /setup.python.sh
RUN /setup.python.sh $PYTHON_VERSION /cpu.requirements.txt
RUN python3 -m pip install --upgrade pip && pip install --no-cache-dir ${TENSORFLOW_PACKAGE} 

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc
