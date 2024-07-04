# KAIROS-CADET-E3
To install KAIROS in a clean, brand-new container, refer [Install guide](https://github.com/iridium-soda/kairos/blob/main/DARPA/CADETS_E3/install/KAIROS%20installation%20guide.md).

## Experiment Hints

### Claenup environments
为了重复执行代码以测试多种实验目标，需要在每次运行之前完全清空之前的运行记录。注意这可能会导致所有流程需要重新执行。
```shell
make clean
```
注意：这里把默认的postgresql用户postgres改为了root，在其他环境下可能会产生未知问题，请保证具有root权限并在root下运行。
### Run background