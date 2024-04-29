# Use Ubuntu latest as the base image
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Install necessary utilities and software-properties-common for adding repositories
RUN apt-get update && \
    apt-get install -y wget apt-transport-https software-properties-common

# Download the Microsoft package signing key and add the package repository
RUN wget https://packages.microsoft.com/config/ubuntu/$(. /etc/os-release && echo $VERSION_ID)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

# Install the .NET SDK 8
RUN apt-get update && \
    apt-get install -y dotnet-sdk-8.0

# Optionally, install the ASP.NET Core Runtime if you only need to run web applications
# RUN apt-get install -y aspnetcore-runtime-8.0

# Optionally, install the .NET Runtime Environment if you only need to run console apps
# RUN apt-get install -y dotnet-runtime-8.0

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# # Define any environment variables
# ENV DOTNET_RUNNING_IN_CONTAINER=true \
#     DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true