FROM ubuntu:24.04

ARG RUNNER_VERSION=2.334.0

ENV RUNNER_USER_UID=1001
ENV DOCKER_GROUP_GID=121

ENV DEBIAN_FRONTEND=noninteractive

RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    add-apt-repository -y ppa:git-core/ppa  && \
    cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF 


RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    curl  zip unzip\
    ca-certificates \
    git \
    git-lfs\
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
    docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*


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
    curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz &&\
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz 

COPY --chmod=755 startup.sh /home/runner/startup.sh

ENTRYPOINT [ "/home/runner/startup.sh" ] 
