FROM node:slim
LABEL Name=hardened-node-slim \
      createdby=ruslanbahna

# End users should not be accessing the terminal and interact using DevOps or scripts instead.
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm

RUN \
    --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    # Always upgrade to the latest version of packages even if the base image is published regularly.
    # For explanation of unusual switches, see https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy
    apt-get --no-install-recommends --quiet --yes -o Dpkg::Use-Pty=0 upgrade && \
    # Specifically update vulnerable packages (if fixed versions are available)
    apt-get install --only-upgrade -y libgnutls30 zlib1g && \
    # Remove unused packages left over from the upgrade.
    apt-get --yes autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add your application's setup steps below

