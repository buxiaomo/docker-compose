# MySql主从编排

通过脚本将主从配置过程Shell化并挂载到从库镜像中的 `/docker-entrypoint-initdb.d`，添加执行权限，以完成主从的配置过程，减少重新构建的步骤与管理，若想完善，直接修改 `slave/init.sh` 脚本即可。

# 环境变量说明

若主库设置了 `MYSQL_DATABASE` 、 `MYSQL_USER` 、 `MYSQL_PASSWORD`这几个环境变量，请复制一份到从库的环境变量中。

`MYSQL_MASTER_HOST` 设置为主库的内部服务名，默认：master

`MYSQL_MASTER_PASSWORD` 设置为主库的root密码，默认：root

`MYSQL_REPLICATION_USER` 设置为主库的复制用户，默认：replication

`MYSQL_REPLICATION_PASSWORD` 设置为主库的复制密码，默认：replication

# 服务健康检查

修改编排 `healthcheck.test` 字段中 `-p` 参数为 `MYSQL_ROOT_PASSWORD`, 并取消注释。