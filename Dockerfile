FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PORT=8080

ARG ROOT_PASSWORD=123456

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        nodejs \
        ca-certificates \
        curl \
        wget \
        nano \
        vim \
        git \
        jq \
        unzip \
        zip \
        iproute2 \
        iputils-ping \
        net-tools \
        procps \
    && mkdir -p /var/run/sshd \
    && printf 'root:%s\n' "$ROOT_PASSWORD" | chpasswd \
    && printf '%s\n' \
        'PermitRootLogin yes' \
        'PasswordAuthentication yes' \
        'UsePAM yes' \
        >> /etc/ssh/sshd_config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY server.js index.html ./

EXPOSE 6080 5901 25565 22 8080

CMD ["bash", "-lc", "/usr/sbin/sshd -D -e & exec node /root/server.js"]
