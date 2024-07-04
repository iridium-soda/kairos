# KAIROS-CADET-E3
To install KAIROS in a clean, brand-new container, refer [Install guide](https://github.com/iridium-soda/kairos/blob/main/DARPA/CADETS_E3/install/KAIROS%20installation%20guide.md).

## Experiment 



### Claenup environments
为了重复执行代码以测试多种实验目标，需要在每次运行之前完全清空之前的运行记录。注意这可能会导致所有流程需要重新执行。
```shell
make clean
```
注意：这里把默认的postgresql用户postgres改为了root，在其他环境下可能会产生未知问题，请保证具有root权限并在root下运行。
### Run 

全量测试（可能消耗大量的时间，约1天左右）：

**NOTE:注意检查模型路径是否重置正确** 见[Guidelines](https://github.com/iridium-soda/kairos/blob/main/DARPA/CADETS_E3/install/KAIROS%20installation%20guide.md#%E8%BF%90%E8%A1%8C%E9%A2%84%E8%AE%AD%E7%BB%83%E6%A8%A1%E5%9E%8B)
```shell
nohup make pipeline > output.txt 2>&1 &
```

预训练模型评估：

下载和配置模型见[Guidelines](https://github.com/iridium-soda/kairos/blob/main/DARPA/CADETS_E3/install/KAIROS%20installation%20guide.md#%E8%BF%90%E8%A1%8C%E9%A2%84%E8%AE%AD%E7%BB%83%E6%A8%A1%E5%9E%8B)
之后
```shell
nohup make pretrained > output.txt 2>&1 &
```

### Trouble shooting

如果报 `permission denied for schema public`之类的问题，执行下面的命令：
```shell
su - postgres
psql
create database tc_cadet_dataset_db;
\connect tc_cadet_dataset_db;
grant all on schema public to root;
```