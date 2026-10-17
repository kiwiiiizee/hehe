FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PORT=8080

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
    && printf '%s\n' \
        'PermitRootLogin yes' \
        'PasswordAuthentication yes' \
        'UsePAM yes' \
        >> /etc/ssh/sshd_config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY server.js index.html ./
COPY start.sh ./
RUN chmod +x /root/start.sh

EXPOSE 6080 5901 25565 22 8080

CMD ["/root/start.sh"]
