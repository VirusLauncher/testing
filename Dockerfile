FROM arm64v8/debian:buster-slim

LABEL author="Kris Dookharan" maintainer="krisdookharan15@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

## add container user
RUN useradd -m -d /home/container -s /bin/bash container

RUN ln -s /home/container/ /nonexistent

ENV USER=container HOME=/home/container

## update base packages
RUN apt update \
 && apt upgrade -y

## install dependencies
RUN apt-get install -y ffmpeg iproute2 git sqlite3 python3 ca-certificates tzdata dnsutils build-essential locales

## install box64
RUN git clone https://github.com/ptitSeb/box64 \
    && cd box64 \
    && mkdir build; cd build; cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    && make -j$(nproc) \
    && make install \
    && systemctl restart systemd-binfmt

## configure locale
RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
