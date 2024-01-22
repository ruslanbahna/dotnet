FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy

# Install necessary tools
RUN apt-get update && apt-get install -y nuget

# Create a temporary project to update the package
RUN mkdir /tmp/update-project
WORKDIR /tmp/update-project
RUN dotnet new console
RUN dotnet add package System.Data.SqlClient --version 4.8.6

# Clean up
WORKDIR /
RUN rm -rf /tmp/update-project