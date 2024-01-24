# FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy

# # Install necessary tools
# RUN apt-get update && apt-get install -y nuget

# # Create a temporary project to force an update of the package
# WORKDIR /tmp/update-project
# RUN dotnet new console
# RUN dotnet add package System.Data.SqlClient --version 4.8.6

# # Copy the updated packages to the .NET SDK directory
# RUN cp -r /tmp/update-project/bin/Debug/net6.0/* /usr/share/dotnet/sdk/8.0.101/

# # Clean up
# WORKDIR /
# RUN rm -rf /tmp/update-project


# Use a base image, for example:
# FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy

# # Install necessary tools
# RUN apt-get update && apt-get install -y nuget
# RUN apt-get update && apt-get dist-upgrade -y

# # Create a temporary project to force an update of the package
# WORKDIR /tmp/update-project
# RUN dotnet new console

# # Update the System.Data.SqlClient package
# # (Note: Since you don't have a project file, you can't use dotnet add package)
# # Manually remove the vulnerable DLL file from your image
# RUN find / -name "System.Data.SqlClient.dll" -delete

# # Publish the project to resolve and include all dependencies
# RUN dotnet publish -c Release -o /published-app

# # Final image
# FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
# COPY --from=0 /published-app /app

# Use a base image as the starting point
# Use a specific version of Ubuntu as the base image
# Use Ubuntu 22.04 as the base image
# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set frontend to noninteractive to avoid timezone prompt
ENV DEBIAN_FRONTEND=noninteractive

# Add Microsoft package signing key and package repository
RUN apt-get update \
    && apt-get install -y wget apt-transport-https software-properties-common \
    && wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# Install the .NET SDK 8.0
RUN apt-get update \
    && apt-get install -y dotnet-sdk-8.0 jq moreutils nuget
RUN jq 'del(.libraries["System.Drawing.Common/4.7.0"])' /usr/share/dotnet/sdk/*/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json | sponge /usr/share/dotnet/sdk/*/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json

# Clean up the package lists
RUN apt-get clean && rm -rf /var/lib/apt/lists/*




