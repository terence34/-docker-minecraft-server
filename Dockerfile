# Minecraft 1.19 Dockerfile
# **************************************************
# This is a Dockerfile which is in progress...
# It doesn't work at the moment
# **************************************************

FROM alpine:3.14
RUN apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

ARG version=1.19

# ARG BASE_IMAGE=eclipse-temurin:17-jre-focal
# FROM ${BASE_IMAGE}

EXPOSE 25565 25575

VOLUME ["/data"]
WORKDIR /data

STOPSIGNAL SIGTERM

# End user MUST set EULA and change RCON_PASSWORD
ENV TYPE=VANILLA VERSION=LATEST EULA="" UID=1000 GID=1000 RCON_PASSWORD=minecraft

COPY --chmod=755 scripts/start* /
COPY --chmod=755 bin/ /usr/local/bin/
COPY --chmod=755 bin/mc-health /health.sh
COPY --chmod=644 files/server.properties /tmp/server.properties
COPY --chmod=644 files/log4j2.xml /tmp/log4j2.xml
COPY --chmod=755 files/autopause /autopause
COPY --chmod=755 files/autostop /autostop
COPY --chmod=755 files/rconcmds /rconcmds

RUN dos2unix /start* /autopause/* /autostop/* /rconcmds/*

ENTRYPOINT [ "/start" ]
HEALTHCHECK --start-period=1m CMD mc-health
