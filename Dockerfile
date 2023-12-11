FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-label=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#         jq \
#         moreutils


# # Use jq to update the JSON file
# RUN jq 'del(.libraries["System.Drawing.Common/4.7.0"])' /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json | sponge /usr/share/dotnet/sdk/8.0.100/Roslyn/Microsoft.Build.Tasks.CodeAnalysis.deps.json
RUN \
    # --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    # apt-get update ; \
    apt install --no-install-recomends --yes wget ; \
    declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi) ; \
    wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb ; \
    dpkg -i packages-microsoft-prod.deb ; \
    rm packages-microsoft-prod.deb ; \
    apt update ; \
    apt install -y libc6 libgcc1 libgcc-s1 libgssapi-krb5-2 libicu70 liblttng-ust1 libssl3 libstdc++6 libunwind8 zlib1g ; \
    apt install -y dotnet-sdk-8.0 ; \