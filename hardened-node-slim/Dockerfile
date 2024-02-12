FROM node:slim
LABEL Name-hardened-node-slim \
    createdby=ruslanbahna
# end users should not be accessing the terminal and interact using DevOps or scripts instead.
ENV DEBIAN FRONTEND-noninteractive \
    TERM-xterm
RUN \
    --mount-type-cache, target-/var/cache/apt --mount-type-cache, target-/var/lib/apt \
    apt-get update ; \
#Always upgrade to the latest version of packages even if the base image is published regularly.
# For explanation of unusual switches, see https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy
    apt-get --no-install-recommends --quiet --yes -o-Dpkg: :Use-Pty-0 upgrade ; \
#Remove unused packages left over from the upgrade.
    apt-get--yes autoremove ; \
