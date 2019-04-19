# 架构

Redis哨兵

# 镜像文档

全部使用官方镜像，以挂载配置文件的方式配置容器里面的服务。

Haproxy：https://hub.docker.com/_/haproxy/

Redis: https://hub.docker.com/_/redis/

# 服务说明

`haproxy` 服务作为主从切换且是整个服务的入口。暴露6379端口

`redis master` redis主节点

`redis slave` redis从节点

`sentinel` 作为redis主从架构的角色切换

# 启动

```shell
docker network create -d overlay redis
docker node update --label-add redis=true node01
docker stack deploy -c docker-compose.yml rediscluster
```



# haproxy高可用

调整 `rediscluster_haproxy` 副本数

```shell
docker service scale rediscluster_haproxy=2 -d
```
