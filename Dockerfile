# Use the official .NET SDK image as a build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the application source code into the container
COPY . .

# Build the application
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image as the final image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Set the entry point for the application
ENTRYPOINT ["dotnet", "HelloWorldApp.dll"]
