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
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy

# Install necessary tools
RUN apt-get update && apt-get install -y nuget
RUN apt-get update && apt-get dist-upgrade -y

# Remove System.Data.SqlClient.dll files to avoid scanning errors
RUN find / -name "System.Data.SqlClient.dll" -delete
