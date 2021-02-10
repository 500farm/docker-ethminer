# Ethereum CUDA Miner

Docker container for Ethereum mining with CUDA.

Based on [Anthony-Tatowicz/docker-ethminer](https://github.com/Anthony-Tatowicz/docker-ethminer).

Works with [vast.ai](https://vast.ai/) on CUDA 11.2 instances.

## How to run

Check the requirements:

- Ubuntu 20.04.* LTS.
- Nvidia drivers for your GPU, you can get them here: [Nvidia drivers](http://www.nvidia.com/Download/index.aspx).
- Nvidia-docker (so docker can access your GPU) install instructions here: [nvidia-docker](https://github.com/NVIDIA/nvidia-docker).

Use the pre-built container: https://hub.docker.com/r/sergeycheperis/docker-ethminer.

Example:
```
$ nvidia-docker run -it sergeycheperis/docker-ethminer ARG1 ARG2 ...
```

Example for *ethermine.org*:

```
$ nvidia-docker run -it sergeycheperis/docker-ethminer \
    -P stratum+tcp://<your_wallet_address>@eu1.ethermine.org:4444
```

Following args are added automatically: `-U --api-bind -3333 --HWMON 2` 

## How to build

This image builds the latest master of https://github.com/ethereum-mining/ethminer.

```
docker build .
docker tag <image_id> sergeycheperis/docker-ethminer:<version>
docker tag <image_id> sergeycheperis/docker-ethminer:latest
docker push sergeycheperis/docker-ethminer:<version>
docker push sergeycheperis/docker-ethminer:latest
```
