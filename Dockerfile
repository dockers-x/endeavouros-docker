# syntax=docker/dockerfile:1.7

# Use the Arch Linux base image
FROM archlinux:latest

ARG SCRIPTS_SHA=local

ENV SHELL=/usr/bin/fish

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Keep Dockerfile orchestration thin; package lists and install details live in scripts/.
# BuildKit mounts scripts only while each step runs, so they are not retained.
RUN --mount=type=bind,source=scripts,target=/usr/local/lib/endeavouros-docker,readonly \
    echo "${SCRIPTS_SHA}" >/dev/null && \
    bash /usr/local/lib/endeavouros-docker/01-install-archlinux-base.sh
RUN --mount=type=bind,source=scripts,target=/usr/local/lib/endeavouros-docker,readonly \
    echo "${SCRIPTS_SHA}" >/dev/null && \
    bash /usr/local/lib/endeavouros-docker/02-install-endeavouros.sh
RUN --mount=type=bind,source=scripts,target=/usr/local/lib/endeavouros-docker,readonly \
    echo "${SCRIPTS_SHA}" >/dev/null && \
    bash /usr/local/lib/endeavouros-docker/03-configure-fish-defaults.sh
RUN --mount=type=bind,source=scripts,target=/usr/local/lib/endeavouros-docker,readonly \
    echo "${SCRIPTS_SHA}" >/dev/null && \
    bash /usr/local/lib/endeavouros-docker/04-write-os-release.sh

# Set fish as the default interactive shell.
CMD ["fish"]
