FROM nvidia/cuda:11.1-devel-ubuntu16.04

MAINTAINER Sergey Cheperis

WORKDIR /

# Package and dependency setup
RUN apt-get update \
    && apt-get install -y git \
    cmake \
    mesa-common-dev \
    build-essential

# Git repo set up
RUN git clone https://github.com/ethereum-mining/ethminer.git; \
    cd ethminer; \
    git submodule update --init --recursive

# Build
RUN cd ethminer; \
    mkdir build; \
    cd build; \
    cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF -DETHSTRATUM=ON; \
    cmake --build .; \
    make install

ENTRYPOINT ["/usr/local/bin/ethminer", "-U"]
