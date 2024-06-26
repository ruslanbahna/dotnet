# # setup build image
# FROM golang:1.22.4 AS operator-build

# RUN --mount=type=cache,target=/var/cache/apt apt-get update ; \
#     apt-get install -y libbtrfs-dev libdevmapper-dev unzip git ; \
#     git clone https://github.com/Dynatrace/dynatrace-operator.git ; 

# WORKDIR /app

# RUN \
#     cp /go/dynatrace-operator/go.mod ./ ; \
#     cp /go/dynatrace-operator/go.sum ./ ; \
#     go mod download -x ; \
#     cp -r /go/dynatrace-operator/pkg ./ ; \
#     cp -r /go/dynatrace-operator/cmd ./ ; \
#     rm -rf /go/dynatrace-operator


# ARG GO_LINKER_ARGS
# ARG GO_BUILD_TAGS

# RUN --mount=type=cache,target="/root/.cache/go-build" CGO_ENABLED=1 CGO_CFLAGS="-O2 -Wno-return-local-addr" \
#     go build -tags "${GO_BUILD_TAGS}" -trimpath -ldflags="${GO_LINKER_ARGS}" \
#     -o ./build/_output/bin/dynatrace-operator ./cmd/

# FROM registry.access.redhat.com/ubi9-micro:9.4-9 AS base
# FROM registry.access.redhat.com/ubi9:9.4-1123 AS dependency
# RUN mkdir -p /tmp/rootfs-dependency
# COPY --from=base / /tmp/rootfs-dependency
# RUN dnf install --installroot /tmp/rootfs-dependency \
#       util-linux-core tar \
#       --releasever 9 \
#       --setopt install_weak_deps=false \
#       --nodocs -y \
#  && dnf --installroot /tmp/rootfs-dependency clean all \
#  && rm -rf \
#       /tmp/rootfs-dependency/var/cache/* \
#       /tmp/rootfs-dependency/var/log/dnf* \
#       /tmp/rootfs-dependency/var/log/yum.*

# FROM base

# COPY --from=dependency /tmp/rootfs-dependency /

# # operator binary
# COPY --from=operator-build /app/build/_output/bin /usr/local/bin

# # csi binaries
# COPY --from=registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.10.1 /csi-node-driver-registrar /usr/local/bin
# COPY --from=registry.k8s.io/sig-storage/livenessprobe:v2.12.0 /livenessprobe /usr/local/bin


# # custom scripts
# COPY ./scripts/entrypoint /usr/local/bin
# COPY ./scripts/user_setup /usr/local/bin

# RUN chmod a+x /usr/local/bin/entrypoint /usr/local/bin/user_setup


# LABEL name="Dynatrace Operator" \
#       vendor="Dynatrace LLC" \
#       maintainer="Dynatrace LLC" \
#       version="1.x" \
#       release="1" \
#       url="https://www.dynatrace.com" \
#       summary="The Dynatrace Operator is an open source Kubernetes Operator for easily deploying and managing Dynatrace components for Kubernetes / OpenShift observability. By leveraging the Dynatrace Operator you can innovate faster with the full potential of Kubernetes / OpenShift and Dynatrace’s best-in-class observability and intelligent automation." \
#       description="Automate Kubernetes observability with Dynatrace" \
#       io.k8s.description="Automate Kubernetes observability with Dynatrace" \
#       io.k8s.display-name="Dynatrace Operator" \
#       io.openshift.tags="observability,monitoring,dynatrace,operator,logging,metrics,tracing,prometheus,alerts" \
#       vcs-url="https://github.com/Dynatrace/dynatrace-operator.git" \
#       vcs-type="git" \
#       changelog-url="https://github.com/Dynatrace/dynatrace-operator/releases"

# ENV OPERATOR=dynatrace-operator \
#     USER_UID=1001 \
#     USER_NAME=dynatrace-operator

# RUN /usr/local/bin/user_setup

# ENTRYPOINT ["/usr/local/bin/entrypoint"]

# USER ${USER_UID}:${USER_UID}
# Stage 1: Build Dynatrace Operator with patched Go
FROM golang:1.22.4 AS operator-build

# Install necessary dependencies and clone the Dynatrace Operator repository
RUN apt-get update && \
    apt-get install -y libbtrfs-dev libdevmapper-dev unzip git && \
    git clone https://github.com/Dynatrace/dynatrace-operator.git /go/dynatrace-operator

WORKDIR /go/dynatrace-operator

# Download Go modules and build the Dynatrace Operator binary
RUN cp go.mod go.sum /app/ && cd /app && go mod download && \
    cp -r pkg cmd /app && cd /app && \
    CGO_ENABLED=1 CGO_CFLAGS="-O2 -Wno-return-local-addr" \
    go build -trimpath -o /app/build/_output/bin/dynatrace-operator ./cmd/

# Stage 2: Create a minimal Red Hat UBI base image
FROM registry.access.redhat.com/ubi9-micro:9.4-9 AS base

# Install necessary utilities in the final image
RUN microdnf install util-linux-core tar && \
    microdnf clean all && \
    rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

# operator binary
COPY --from=operator-build /app/build/_output/bin/dynatrace-operator /usr/local/bin/dynatrace-operator

# csi binaries
COPY --from=registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.10.1 /csi-node-driver-registrar /usr/local/bin/csi-node-driver-registrar
COPY --from=registry.k8s.io/sig-storage/livenessprobe:v2.12.0 /livenessprobe /usr/local/bin/livenessprobe

# Copy custom scripts and make them executable
COPY ./scripts/entrypoint /usr/local/bin/entrypoint
COPY ./scripts/user_setup /usr/local/bin/user_setup
RUN chmod a+x /usr/local/bin/entrypoint /usr/local/bin/user_setup

# Metadata
LABEL name="Dynatrace Operator" \
      vendor="Dynatrace LLC" \
      maintainer="Dynatrace LLC" \
      version="1.x" \
      release="1" \
      url="https://www.dynatrace.com" \
      summary="The Dynatrace Operator is an open source Kubernetes Operator for easily deploying and managing Dynatrace components for Kubernetes / OpenShift observability. By leveraging the Dynatrace Operator you can innovate faster with the full potential of Kubernetes / OpenShift and Dynatrace’s best-in-class observability and intelligent automation." \
      description="Automate Kubernetes observability with Dynatrace" \
      io.k8s.description="Automate Kubernetes observability with Dynatrace" \
      io.k8s.display-name="Dynatrace Operator" \
      io.openshift.tags="observability,monitoring,dynatrace,operator,logging,metrics,tracing,prometheus,alerts" \
      vcs-url="https://github.com/Dynatrace/dynatrace-operator.git" \
      vcs-type="git" \
      changelog-url="https://github.com/Dynatrace/dynatrace-operator/releases"

# Environment variables and user setup
ENV OPERATOR=dynatrace-operator \
    USER_UID=1001 \
    USER_NAME=dynatrace-operator

RUN /usr/local/bin/user_setup

# Set the entrypoint and user
ENTRYPOINT ["/usr/local/bin/entrypoint"]
USER ${USER_UID}:${USER_UID}