FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        wget \
        nano \
        vim \
        git \
        jq \
        unzip \
        zip \
        sudo \
        iproute2 \
        iputils-ping \
        net-tools \
        procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

EXPOSE 6080 5901 25565 22

CMD ["/bin/bash"]
