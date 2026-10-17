FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    ROOT_PASSWORD=123456

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
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

EXPOSE 6080 5901 25565 22

CMD ["/usr/sbin/sshd", "-D", "-e"]
