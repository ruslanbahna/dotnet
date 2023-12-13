# Stage 1: Build the .NET Core application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the source code
COPY ./src /app

# Restore dependencies and build
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Stage 2: Create a smaller runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "myapp.dll"]