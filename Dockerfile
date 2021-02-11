FROM nvidia/cuda:11.2.0-devel-ubuntu20.04 AS build-stage

WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive

# Package and dependency setup
RUN apt-get update \
    && apt-get install -y git cmake mesa-common-dev build-essential

# Git repo set up
RUN git clone https://github.com/ethereum-mining/ethminer.git \
    && cd ethminer \
    && git submodule update --init --recursive

# Build
RUN cd ethminer \
    && mkdir build \
    && cd build \
    && cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF -DETHSTRATUM=ON -DAPICORE=ON \
    && cmake --build . \
    && make install


FROM nvidia/cuda:11.2.0-runtime-ubuntu20.04

WORKDIR /usr/local/bin

COPY --from=build-stage /usr/local/bin/ethminer .

ENTRYPOINT ["/usr/local/bin/ethminer", "-U", "--HWMON", "2", "--api-port", "-3333"]
EXPOSE 3333

MAINTAINER Sergey Cheperis
