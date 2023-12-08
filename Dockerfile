FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy
LABEL my-labe=hardened-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xtern

RUN apt update \
    && apt --no-install-recommends -o=Dpkg::Use-Pty=0 upgrade \
    && apt --yes autoremove
RUN dotnet add package System.Drawing.Common --version 8.0.0