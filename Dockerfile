FROM ubuntu:16.04

MAINTAINER scornflake

# Requirements
RUN apt-get -y update
RUN apt-get -y install lib32gcc1 wget

# Install steamcmd
RUN mkdir -p /steamcmd
WORKDIR /steamcmd
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz

# Open file limit
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN sysctl -p /etc/sysctl.conf

RUN echo "*               soft    nofile          1000000" >> /etc/security/limits.conf
RUN echo "*               hard    nofile          1000000" >> /etc/security/limits.conf

RUN echo "session required pam_limits.so" >> /etc/pam.d/common-session

#Install game
RUN mkdir -p /server/ark
WORKDIR /server

ENV SERVERPATH "/server/ark"
ENV ARK_RCON 32330
ENV MAPNAME "TheIsland"

COPY ark_start.sh ./
RUN chmod +x ark_start.sh


# Game client port
EXPOSE 7777/udp

# Game RAW UDP port (always +1 game port)
EXPOSE 7778/udp

# Query port for steams service browser
EXPOSE 27015/udp

# ARK RCON
EXPOSE 32330/tcp

VOLUME /server/ark

CMD ./ark_start.sh
