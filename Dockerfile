# Use the .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the application source code
COPY ./MyHelloWorldApp.csproj .
COPY ./Program.cs .

# Restore dependencies and build the application
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Create a runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/out .

# Set the entry point for the container
ENTRYPOINT ["dotnet", "MyHelloWorldApp.dll"]
