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
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy

# Install necessary tools
RUN apt-get update && apt-get install -y nuget

# Create a temporary project to force an update of the package
WORKDIR /tmp/update-project
RUN dotnet new console
RUN dotnet add package System.Data.SqlClient --version 4.8.6

# Build the project to generate the bin/Debug directory
RUN dotnet build

# List files in the project directory to verify the path
RUN ls /tmp/update-project/bin/Debug/

# (Optional) Copy the updated packages to the .NET SDK directory
# Adjust the paths according to the output of the 'ls' command
# RUN cp -r /tmp/update-project/bin/Debug/net6.0/* /usr/share/dotnet/sdk/8.0.101/ || (echo "Copy failed" && exit 1)

# Clean up
WORKDIR /
RUN rm -rf /tmp/update-project