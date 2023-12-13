# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# Copy the .csproj file and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the application source code
COPY . .

# Build the application
RUN dotnet publish -c Release -o /app --no-restore

# Stage 2: Create a runtime image
FROM mcr.microsoft.com/dotnet/runtime:6.0 AS runtime
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app .

# Set the entry point for the container
ENTRYPOINT ["dotnet", "MyHelloWorldApp.dll"]