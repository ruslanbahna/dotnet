# Use Ubuntu latest as the base image
FROM ubuntu:latest

# Install necessary utilities and software-properties-common for adding repositories
RUN apt-get update && \
    apt-get install -y wget apt-transport-https software-properties-common gnupg2

# Add the Microsoft package signing key and package repository
RUN wget https://packages.microsoft.com/config/ubuntu/$(. /etc/os-release && echo $VERSION_ID)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb


# Install the .NET SDK 8. 
RUN apt-get update && \
    apt-get install -y dotnet-sdk-8.0

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

