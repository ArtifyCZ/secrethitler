FROM ghcr.io/linuxserver/code-server

RUN apt update && apt upgrade -y && apt dist-upgrade -y

RUN apt install -y python3-pip

ENV PATH=$PATH:/config/.local/bin/
