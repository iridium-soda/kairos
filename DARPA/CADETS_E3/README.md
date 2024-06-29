# Install KAIROS in CADETS_E3

本文档为经过验证之后的在KAIROS上运行的简便方法，基于`DARPA/CADETS_E3/KAIROS installation guide.md`

## CADETS

### 创建运行容器并初始化

创建一个包含gpu的基于ubuntu22.04的cuda容器，并挂载cadet数据集

```shell
docker run -itd --name cadets --gpus all  --mount type=bind,source=$PWD/kairos_cadets,target=/root/  --mount type=bind,source=/raw_logs/cadets_e3,target=/raw_data/ -p 8996:22 nvidia/cuda:12.5.0-devel-ubuntu22.04 /bin/bash
```

进入容器后进行环境初始化，并检查cuda环境

```shell
nvidia-smi
```

```
Thu Jun 27 09:36:41 2024       
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.86.10              Driver Version: 535.86.10    CUDA Version: 12.5     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA RTX A6000               Off | 00000000:1B:00.0 Off |                  Off |
| 30%   43C    P2              71W / 300W |  21636MiB / 49140MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   1  NVIDIA RTX A6000               Off | 00000000:88:00.0 Off |                  Off |
| 30%   28C    P8              17W / 300W |      5MiB / 49140MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
+---------------------------------------------------------------------------------------+
```

### 安装环境

#### Anaconda

[Installing conda — conda 24.5.1.dev56 documentation](https://conda.io/projects/conda/en/latest/user-guide/install/index.html)

```bash
wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
bash Anaconda-latest-Linux-x86_64.sh
```

设置为默认启动

```shell
cp .bashrc  ~/.profile
```

#### PostgresSQL

[How to Install and Setup PostgreSQL on Ubuntu 20.04 | Step-by-Step | Cherry Servers](https://www.cherryservers.com/blog/how-to-install-and-setup-postgresql-server-on-ubuntu-20-04)

```shell
 apt install wget ca-certificates
 wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
```

```shell
apt update
apt install postgresql postgresql-contrib
```

Check status:

```shell
service postgresql status
```

这时候会显示

```
16/main (port 5432): down
```

需要手动拉起

```shell
pg_ctlcluster 16 main start
```

之后就是online

```
16/main (port 5432): online
```

#### GraphViz

```shell
apt-get install graphviz graphviz-doc
```

#### Clone repo

```shell
git clone https://github.com/ProvenanceAnalytics/kairos.git
```

#### Conda虚拟环境和python依赖
> 手动安装的方法见`DARPA/CADETS_E3/KAIROS installation guide.md`

自动导入
```shell
conda create env -f environment.yml
conda activate kairos
```
手动安装的部分
```shell
pip install ./whls/*.whl
```

