# 基于Docker Swarm Cluster部署Splunk Cluster

## 安装Docker

略 (请安装17.12以上的版本)

## 配置Docker Swarm Cluster

略

## 主机节点

| 主机名 | IP地址 | Splunk角色 |
| :- | :-- | :-- |
| splunk-search01 | 10.211.55.29 | Splunk Search |
| splunk-index01 | 10.211.55.30 | Splunk Index, Splunk Slave License Server |
| splunk-index02 | 10.211.55.31 | Splunk Index, Splunk Slave License Server |
| splunk-master | 10.211.55.33 | Splunk Master |
| splunk-licenser | 10.211.55.34 | Splunk Master License Server |
| splunk-deployment | 10.211.55.35 | Splunk Deployment Server |
| splunk-fd01 | 10.211.55.32 | Splunk Forword |

## 修改编排

替换编排文件中的 SPLUNK_DEPLOYMENT_SERVER_IP、SPLUNK_MASTER_SERVER_IP、SPLUNK_LICENS_SERVER_IP为对应的IP地址

```shell
SPLUNK_DEPLOYMENT_SERVER_IP=10.0.3.51
SPLUNK_MASTER_SERVER_IP=10.0.3.51
SPLUNK_LICENS_SERVER_IP=10.0.3.51

sed -i "s/SPLUNK_DEPLOYMENT_SERVER_IP/${SPLUNK_DEPLOYMENT_SERVER_IP}/g" splunk_cluster.yml
sed -i "s/SPLUNK_MASTER_SERVER_IP/${SPLUNK_MASTER_SERVER_IP}/g" splunk_cluster.yml
sed -i "s/SPLUNK_LICENS_SERVER_IP/${SPLUNK_LICENS_SERVER_IP}/g" splunk_cluster.yml

```

## 配置主机角色

```shell
docker node update --label-add splunk=searchead01 splunk-search
docker node update --label-add splunk=master splunk-master
docker node update --label-add splunk=indexer01 splunk-index01
docker node update --label-add splunk=indexer02 splunk-index02
docker node update --label-add splunk=licenser splunk-licenser
docker node update --label-add splunk=deployment splunk-deployment
```

## 部署集群

启动方法，查看 `deploy.sh` 与 `uninstall-universalforwarder.sh` 脚本逻辑

```shell
./deploy.sh
```

## 访问集群

http://10.211.55.29:8000