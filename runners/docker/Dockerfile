FROM ubuntu:24.04

ARG TARGETPLATFORM=linux/x86_64
ARG RUNNER_VERSION=2.334.0
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.8.1
# Docker and Docker Compose arguments
ENV CHANNEL=stable
ARG DOCKER_VERSION=28.0.4
ARG DOCKER_COMPOSE_VERSION=v2.38.2
ARG DUMB_INIT_VERSION=1.2.5
ARG RUNNER_USER_UID=1001
ARG DOCKER_GROUP_GID=121

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    curl  zip unzip\
    ca-certificates \
    git \
    iptables \
    jq \
    software-properties-common \
    sudo \
    fuse-overlayfs \
    openjdk-21-jdk \
    python3-pip  \
    python3-requests\
    python3-virtualenv \
    maven \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -y --no-install-recommends git-lfs

RUN adduser --disabled-password --gecos "" --uid $RUNNER_USER_UID --home /home/runner runner \
    && groupadd docker --gid $DOCKER_GROUP_GID \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

USER runner

ENV HOME=/home/runner

WORKDIR /home/runner

RUN mkdir $HOME/actions-runner && cd $HOME/actions-runner &&\
    curl -o actions-runner-linux-x64-2.334.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.334.0/actions-runner-linux-x64-2.334.0.tar.gz &&\
    tar xzf ./actions-runner-linux-x64-2.334.0.tar.gz 

COPY --chmod=755 startup.sh /home/runner/startup.sh

ENTRYPOINT [ "/home/runner/startup.sh" ] 
