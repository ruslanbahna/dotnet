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
FROM ubuntu:latest

# Set environment variables to avoid interactive dialog during installations and to set the LANG environment
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip to ensure we can install the latest TensorFlow package
RUN pip3 install --upgrade pip

# Install TensorFlow
RUN pip3 install tensorflow


