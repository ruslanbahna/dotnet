FROM node:alpine

RUN \
    --mount=type=cache,target=/var/cache/apk \
    apk upgrade ;












