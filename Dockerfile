# Use the .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
WORKDIR /source

# Copy the application source code
COPY ./src .

# Build the application
RUN dotnet publish -c Release -o /app

# Create a runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0-jammy AS runtime
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app .

# Set the entry point for the container
ENTRYPOINT ["dotnet", "YourApp.dll"]