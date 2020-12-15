# Ethereum CUDA Miner


### Docker container for Ethereum mining with CUDA.

Simple and easy to run, if you have an Nvidia GPU and want to mine Ethereum.
Based on [Anthony-Tatowicz/docker-ethminer](https://github.com/Anthony-Tatowicz/docker-ethminer).

**Note:** This image builds the latest master of [ethminer](https://github.com/ethereum-mining/ethminer).

### Requirements
- Nvidia drivers for your GPU, you can get them here: [Nvidia drivers](http://www.nvidia.com/Download/index.aspx).
- Nvidia-docker (so docker can access your GPU) install instructions here: [nvidia-docker](https://github.com/NVIDIA/nvidia-docker).

### How to run
```
$ nvidia-docker run -it sergeycheperis/docker-ethminer ARG1 ARG2 ...
```

Example for *ethermine.org*:

```
$ nvidia-docker run -it sergeycheperis/docker-ethminer \
    -P stratum+tcp://<your_wallet_address>@eu1.ethermine.org:4444
```

**Note:** `-U` (use CUDA only) is set by default.

### Help
`$ etherminer --help`
