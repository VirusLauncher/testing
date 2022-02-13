FROM        node:17-buster-slim

LABEL       author="Kris Dookharan" maintainer="krisdookharan15@gmail.com"

RUN         apt update \
    && apt-get install -y ffmpeg iproute2 git sqlite3 python3 ca-certificates tzdata dnsutils build-essential \
    && npm -g install npm@latest \
    && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
