FROM ubuntu:18.04
LABEL maintainer = "Sarcastic Cat cat@sarcasticat.com"

ENV DOLCESDK /home/dolce/dolcesdk
ENV PATH ${DOLCESDK}/bin:${PATH}

RUN \
    echo "Adding non-root user..." && \
    useradd -ms /bin/bash dolce && \
    echo "dolce:dolce" | chpasswd && adduser dolce sudo

RUN \
    DEBIAN_FRONTEND=noninteractive && \
    echo "Installing dependencies..." && \
    apt update && \
    apt install -y sudo python3 tar gzip bzip2 xz-utils curl git make build-essential netcat ftp ninja-build

RUN \
    echo "Installing latest CMake version..." && \
    apt install -y wget apt-transport-https ca-certificates gnupg software-properties-common && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add - && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
    apt-get update && \
    apt-get install -y cmake

WORKDIR ${DOLCESDK}

RUN \
    echo "Installing DolceSDK..." && \
    git clone --depth=1 https://github.com/DolceSDK/ddpm.git && \
    python3 ddpm/dolcesdk-update.py && \
    rm -rf ddpm && \
    chmod -R 777 ${DOLCESDK}

RUN dolcesdk-update-packages

WORKDIR /home/dolce

USER dolce
CMD ["/bin/bash"]
