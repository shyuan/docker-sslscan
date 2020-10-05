FROM ubuntu:20.04

ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN \
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt update && \
    apt upgrade -y && \
    apt install -y build-essential git zlib1g-dev && \
    apt build-dep -y openssl && \
    git clone https://github.com/rbsec/sslscan.git && \
    cd sslscan && \
    make static && \
    make install

RUN \
    export uid=1000 gid=1000 && \
    groupadd --gid ${gid} user && \
    useradd --uid ${uid} --gid ${gid} --create-home user

USER user
WORKDIR /home/user

ENTRYPOINT ["/usr/bin/sslscan"]
