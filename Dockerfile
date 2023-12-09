FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy as builder
LABEL my-label=hardened-sdk

# Create a temporary container to copy the file from the image filesystem
RUN mkdir -p /temp
WORKDIR /temp
COPY /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json .

# Modify the original deps.json file
RUN jq 'your-modification-command-here' Microsoft.Build.Tasks.CodeAnalysis.deps.json > Microsoft.Build.Tasks.CodeAnalysis.modified.deps.json

# Start a new stage to create the final image
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-label=hardened-sdk

# Copy the modified deps.json file from the builder stage
COPY --from=builder /temp/Microsoft.Build.Tasks.CodeAnalysis.modified.deps.json /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json
RUN apt-get update 