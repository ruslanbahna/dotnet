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
FROM python:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Install TensorFlow, replacing '2.x' with the specific version of TensorFlow 2 you wish to use, if necessary
RUN apt update && pip install --upgrade pip && \
    pip install tensorflow

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]

