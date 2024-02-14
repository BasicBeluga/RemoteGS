FROM ubuntu:latest

LABEL maintainer="https://github.com/BasicBeluga/RemoteGS"

ARG SOURCE=https://github.com/JGRennison/OpenTTD-patches
ARG BRANCH=jgrpp-0.57.1

ENV DEBIAN_FRONTEND=noninteractive \
    PORT=3797 \
    ADMIN_PORT=3977 \
    USER_FOLDER=/root/.local/share \
    SOURCE=$SOURCE \
    BRANCH=$BRANCH

# FIX FOR BUILD-DEPS
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# DEPS
RUN apt-get update
RUN apt-get build-dep openttd -y
RUN apt-get install git cmake wget unzip python3 -y

# JGRPP OPENTTD BUILD SETUP
RUN git clone "$SOURCE" --branch="$BRANCH" openttd \
    && mkdir openttd/build

# MAKE OPENTTD
WORKDIR openttd/build/
RUN ls && cmake .. && make --jobs=5
# TODO: Get number of cores allotted

# LOAD USER DIRECTORY
RUN mkdir -p "$USER_FOLDER" \
    && ln -s /opt/openttd "$USER_FOLDER"

# RemoteGS
COPY gen_api_binding.py /openttd/build/game/RemoteGS/gen_api_binding.py
WORKDIR /openttd/build/game/RemoteGS
RUN ls
RUN python3 gen_api_binding.py


# EXPOSE PORTS
EXPOSE $PORT/tcp $PORT/udp
EXPOSE $ADMIN_PORT/tcp $ADMIN_PORT/udp
