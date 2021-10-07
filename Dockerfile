FROM nvidia/cuda:11.2.0-devel-ubuntu20.04 AS build-stage

WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive

# Package and dependency setup
RUN apt-get update \
    && apt-get install -y git cmake mesa-common-dev build-essential wget

# Git repo set up
RUN git clone https://github.com/ethereum-mining/ethminer.git \
    && cd ethminer \
    && git submodule update --init --recursive

# Fix for unable to download boost from bintray.org
# https://github.com/ethereum-mining/ethminer/issues/2290
RUN mkdir -p /root/.hunter/_Base/Download/Boost/1.66.0/075d0b4 \
    && cd /root/.hunter/_Base/Download/Boost/1.66.0/075d0b4 \
    && wget https://boostorg.jfrog.io/artifactory/main/release/1.66.0/source/boost_1_66_0.7z

# Build
RUN cd ethminer \
    && mkdir build \
    && cd build \
    && cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF -DETHSTRATUM=ON -DAPICORE=ON \
    && cmake --build . \
    && make install

#---------------

FROM golang:alpine AS build-stage-go

WORKDIR /usr/local/go/src/build

COPY wrapper/*.go ./
RUN go build -o /usr/local/bin/wrapper .

#---------------

FROM nvidia/cuda:11.2.0-runtime-ubuntu20.04

WORKDIR /usr/local/bin

COPY --from=build-stage /usr/local/bin/ethminer .
COPY --from=build-stage-go /usr/local/bin/wrapper .

ENTRYPOINT ["/usr/local/bin/wrapper", "-U", "--HWMON", "2", "--api-port", "-3333", "--syslog"]
EXPOSE 3333
