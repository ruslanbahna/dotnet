# Use the build image to build and publish the application
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
WORKDIR /source

# Copy the application source code
COPY . .

# Restore dependencies
RUN dotnet restore

# Build the application
RUN dotnet publish -c Release -o /app

# Use a runtime image for the final image
FROM mcr.microsoft.com/dotnet/runtime:8.0-jammy AS runtime
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app .

# Set the entry point for the container
ENTRYPOINT ["dotnet", "YourApp.dll"]