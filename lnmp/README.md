# 部署LNMP

​	集群环境下，自行解决共享存储问题（GFS、NFS），或者注释编排文件中 `placement` 配置

## 本实例知识点

* 学习如何查阅官方镜像的文档，该镜像暴露的端口，配置文件路径，数据目录，有那些环境变量，分别是什么作用。
* 学习容器之间如何通讯(networks.*.aliases),应该使用服务名，网络别名，不要使用links!
* 配置文件如何设置(主机映射，或configs)
* 如何定义容器在那些主机运行(deploy.placement.constraints)
* 如何限制容器资源（deploy.resources.limits）

## Nginx镜像帮助文档
https://hub.docker.com/_/nginx/

## PHP镜像帮助文档
https://hub.docker.com/_/php/

## MYSQL镜像帮助文档
https://hub.docker.com/_/mysql/

## PHPMYADMIN镜像帮助文档
https://hub.docker.com/r/phpmyadmin/phpmyadmin/

# 部署
```shell
# 安装运行环境
make runtime

# 部署应用
make deploy
```

​	服务访问链接：http://${HOSTIP}:80/index.php

​	数据库管理链接：http://${HOSTIP}:81