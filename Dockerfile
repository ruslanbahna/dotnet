# Use the .NET SDK image to build and run the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy the source code into the container
COPY . .

# Build the application
RUN dotnet publish -c Release -o out

# Set the entry point for the container
CMD ["dotnet", "out/MyHelloWorldApp.dll"]