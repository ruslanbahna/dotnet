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

FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build

# Install necessary tools
RUN apt-get update && apt-get install -y nuget
RUN apt-get update && apt-get dist-upgrade -y

# Create a temporary project directory
WORKDIR /tmp/update-project

# Create a simple dummy program
RUN echo 'class Program { static void Main() { } }' > Program.cs

# Create a project file within the image
RUN echo '<Project Sdk="Microsoft.NET.Sdk">' > update-project.csproj && \
    echo '  <PropertyGroup>' >> update-project.csproj && \
    echo '    <OutputType>Exe</OutputType>' >> update-project.csproj && \
    echo '    <TargetFramework>net8.0</TargetFramework>' >> update-project.csproj && \
    echo '  </PropertyGroup>' >> update-project.csproj && \
    echo '  <ItemGroup>' >> update-project.csproj && \
    echo '    <PackageReference Include="System.Data.SqlClient" Version="4.8.6" />' >> update-project.csproj && \
    echo '  </ItemGroup>' >> update-project.csproj && \
    echo '</Project>' >> update-project.csproj

# Restore NuGet packages
RUN dotnet restore

# Publish the project to resolve and include all dependencies
RUN dotnet publish -c Release -o /published-app

# Final image
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
COPY --from=build /published-app /app

COPY --from=0 /published-app /app

