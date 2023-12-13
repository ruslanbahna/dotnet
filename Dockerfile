# Use the .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
WORKDIR /source

# Copy the application source code from the MyHelloWorldApp subdirectory
COPY MyHelloWorldApp/ .

# Restore dependencies and build the application
RUN dotnet restore

RUN dotnet publish --no-restore -o /app
# RUN dotnet publish -c Release -o /app

# Create a runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0-jammy-chiseled AS runtime
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app .

EXPOSE 8080

# Set the entry point for the container
ENTRYPOINT ["dotnet", "MyHelloWorldApp.dll"]
