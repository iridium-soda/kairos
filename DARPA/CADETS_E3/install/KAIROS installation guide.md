# KAIROS installation guide

[TOC]
## Whatis

KAIROS 是针对整个系统的图级别（？）溯源图异常检测工作，提供了无先验知识的0day检测并提供攻击场景重建。见：

[ProvenanceAnalytics/kairos (github.com)](https://github.com/ProvenanceAnalytics/kairos)

```
@inproceedings{cheng2024kairos,
  title={KAIROS: Practical Intrusion Detection and Investigation using Whole-system Provenance},
  author={Cheng, Zijun and Lv, Qiujian and Liang, Jinyuan and Wang, Yang and Sun, Degang and Pasquier, Thomas and Han, Xueyuan},
  booktitle={2024 IEEE Symposium on Security and Privacy (SP)},
  year={2024},
  organization={IEEE}
}
```



用于作为SOTA和我们的工作比较。

该工作预定在CUDA环境下运行，使用数据集为DARPA-TC-E3-CADET/THEIA，StreamSpot。


安装方式有完全手动和部分使用脚本两种模式。默认为全手动，使用脚本的模式在不同的地方标注。此外还有使用镜像直接拉起容器的方法，但镜像还没有公开，并且镜像非常大，建议使用半自动方式安装。总体流程如下：

![image](https://github.com/iridium-soda/kairos/assets/32727642/25ed9eb9-87ba-4dbb-a7b4-ebef1bea0724)


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

这时候如果显示

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

修改用户检查策略：

```shell
vim /etc/postgresql/16/main/pg_hba.conf
```

```diff
-local   all             postgres                                md5
+local   all             postgres                                trust
+local   all             root                                    trust
```

```shell
service postgresql restart
```
#### Timer

```shell
apt install time
```

#### GraphViz

```shell
apt-get install graphviz graphviz-doc
```

#### Clone repo

```shell
git clone https://github.com/ProvenanceAnalytics/kairos.git
```

#### Python env

```shell
conda create -n kairos python=3.9
conda activate kairos
conda install psycopg2 tqdm
conda install scikit-learn==1.2.0 
conda install networkx==2.8.7 numpy==1.22.4 -c conda-forge
pip install xxhash==3.2.0 graphviz==0.20.1


# PyTorch GPU version
conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia
pip install torch_geometric==2.0.0
```
手动安装whl中的内容
```shell
pip install ./DARPA/CADETS_E3/install/whls/*.whl
```

#### Python env自动方法

```shell
conda env create -f ./DARPA/CADETS_E3/environment.yml
```
之后手动安装whl中的内容
```shell
pip install ./DARPA/CADETS_E3/install/whls/*.whl
```



### 配置数据库

切换用户到postgres

```shell
su - postgres
```

启动命令行

```shell
psql
```
给root用户授权
```sql
CREATE ROLE root WITH LOGIN;
ALTER ROLE root WITH PASSWORD NULL;
grant all on schema public to root;
```
创建数据库并连接

```sql

create database tc_cadet_dataset_db;
\connect tc_cadet_dataset_db;
```

创建table

```sql
create table event_table
(
    src_node      varchar,
    src_index_id  varchar,
    operation     varchar,
    dst_node      varchar,
    dst_index_id  varchar,
    timestamp_rec bigint,
    _id           serial
);
```

修改和配置

```sql
alter table event_table owner to root;
create unique index event_table__id_uindex on event_table (_id); grant delete, insert, references, select, trigger, truncate, update on event_table to root;
```

创建文件表

```sql
create table file_node_table
(
    node_uuid varchar not null,
    hash_id   varchar not null,
    path      varchar,
    constraint file_node_table_pk
        primary key (node_uuid, hash_id)
);
alter table file_node_table owner to root;
```

创建网络流列表

```sql
 create table netflow_node_table
(
    node_uuid varchar not null,
    hash_id   varchar not null,
    src_addr  varchar,
    src_port  varchar,
    dst_addr  varchar,
    dst_port  varchar,
    constraint netflow_node_table_pk
        primary key (node_uuid, hash_id)
);
alter table netflow_node_table owner to root;
```

创建实体列表

```sql
create table subject_node_table
(
    node_uuid varchar,
    hash_id   varchar,
    exec      varchar
);
alter table subject_node_table owner to root;
```

创建node2id列表

```sql
create table node2id
(
    hash_id   varchar not null
        constraint node2id_pk
            primary key,
    node_type varchar,
    msg       varchar,
    index_id  bigint
);
alter table node2id owner to root;
```

创建索引

```sql
 create unique index node2id_hash_id_uindex on node2id (hash_id);
```



### 自动化配置数据库

切换用户到postgres

```shell
su - postgres
```

启动命令行

```shell
psql
```

创建数据库并连接

```shell
create database tc_cadet_dataset_db;
\connect tc_cadet_dataset_db;
```

执行脚本
```shell
./DARPA/CADETS_E3/install/init.sql
```


### 配置和运行

```shell
cd kairos/DARPA/CADETS_E3
```

编辑`config.py`，修改该字段为cadet数据集中json文件的目录

```diff
# The directory of the raw logs
- raw_dir = "/the/absolute/path/of/cadets_e3/"
+ raw_dir="/raw_data/"
```

如果修改过postgresql配置，需要相应修改` Database settings`小节的配置。



运行：

```shell
make pipeline
```

### 运行预训练模型

由于训练模型消耗时间极长且资源占用大，原作者给出了预训练模型可以直接评估效果。从[Google Drive](https://drive.google.com/drive/u/0/folders/1YAKoO3G32xlYrCs4BuATt1h_hBvvEB6C)下载预训练模型，并在[test.py](https://github.com/ProvenanceAnalytics/kairos/blob/37044bfd30393c0a0543d3b98f2049cd039cc013/DARPA/CADETS_E3/test.py#L170)这里填入模型路径，随后执行：
```shell
make pretrained
```
### Troubleshooting

#### Import error

```
  File "/root/anaconda3/envs/kairos/lib/python3.9/site-packages/scipy/interpolate/_fitpack_py.py", line 8, in <module>
    from ._fitpack_impl import bisplrep, bisplev, dblint  # noqa: F401
  File "/root/anaconda3/envs/kairos/lib/python3.9/site-packages/scipy/interpolate/_fitpack_impl.py", line 103, in <module>
    'iwrk': array([], dfitpack_int), 'u': array([], float),
TypeError
make: *** [Makefile:5: create_database] Error 1
```

可能是numpy和sklearn版本冲突，检查numpy的版本：

```shell
conda list numpy
```

```
# Name                    Version                   Build  Channel
numpy                     2.0.0                    pypi_0    pypi
numpy-base                1.26.4           py39hb5e798b_0 
```

```shell
pip install --upgrade scipy numpy
```

报

```
Traceback (most recent call last):
  File "/root/kairos/DARPA/CADETS_E3/create_database.py", line 9, in <module>
    from kairos_utils import *
  File "/root/kairos/DARPA/CADETS_E3/kairos_utils.py", line 12, in <module>
    from sklearn.metrics import average_precision_score, roc_auc_score
  File "/root/anaconda3/envs/kairos/lib/python3.9/site-packages/sklearn/__init__.py", line 82, in <module>
    from .base import clone
  File "/root/anaconda3/envs/kairos/lib/python3.9/site-packages/sklearn/base.py", line 17, in <module>
    from .utils import _IS_32BIT
  File "/root/anaconda3/envs/kairos/lib/python3.9/site-packages/sklearn/utils/__init__.py", line 19, in <module>
    from .murmurhash import murmurhash3_32
  File "sklearn/utils/murmurhash.pyx", line 1, in init sklearn.utils.murmurhash
ValueError: numpy.dtype size changed, may indicate binary incompatibility. Expected 96 from C header, got 88 from PyObject
```

可能是numpy版本太新，降级：

```shell
pip install numpy==1.22.4
```

（经过测试，似乎只有这个版本不会太新又不会太旧）

#### postgres

```
psycopg2.OperationalError: FATAL:  Peer authentication failed for user "postgres"
```

按照文档参考这个链接：https://stackoverflow.com/questions/18664074/getting-error-peer-authentication-failed-for-user-postgres-when-trying-to-ge

```shell
vim /etc/postgresql/16/main/pg_hba.conf
```

```diff
-local   all             postgres                                peer
+local   all             postgres                                md5
```

重启服务

```shell
service postgresql restart
```

---

```
psycopg2.OperationalError: FATAL:  password authentication failed for user "postgres"

make: *** [Makefile:5: create_database] Error 1
```

参考：https://www.cnblogs.com/kerrycode/p/14324465.html

```shell
vim /etc/postgresql/16/main/pg_hba.conf
```

```diff
-local   all             postgres                                md5
+local   all             postgres                                trust
```

```shell
service postgresql restart
```



## THEIA



## Stream

