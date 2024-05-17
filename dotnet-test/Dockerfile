# Use the Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    ca-certificates \
    dotnet-sdk-8.0 ;