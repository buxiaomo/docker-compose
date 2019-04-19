#!/bin/bash
set -ex
# 检查主从复制是否正常
check_slave_health () {
    echo Checking replication health:
    status=$(mysql --defaults-file=/tmp/slave.cnf -e "SHOW SLAVE STATUS\G")
    echo "$status" | egrep 'Slave_(IO|SQL)_Running:|Seconds_Behind_Master:|Last_.*_Error:' | grep -v "Error: $"
    if ! echo "$status" | grep -qs "Slave_IO_Running: Yes"    ||
        ! echo "$status" | grep -qs "Slave_SQL_Running: Yes"   ||
        ! echo "$status" | grep -qs "Seconds_Behind_Master: 0" ; then
        echo WARNING: Replication is not healthy.
        return 1
    fi
    return 0
}
# 设置默认值
MYSQL_MASTER_HOST=${MYSQL_MASTER_HOST:-'master'}
MYSQL_MASTER_PASSWORD=${MYSQL_MASTER_PASSWORD:-'root'}
MYSQL_REPLICATION_USER=${MYSQL_REPLICATION_USER:-'replication'}
MYSQL_REPLICATION_PASSWORD=${MYSQL_REPLICATION_PASSWORD:-'replication'}

# 创建配置文件
cat > /tmp/slave.cnf << EOF
[client]
user        = root
password    = ${MYSQL_ROOT_PASSWORD}
port        = 3306
socket      = /var/run/mysqld/mysqld.sock
EOF
cat > /tmp/master.cnf << EOF
[client]
user        = root
password    = ${MYSQL_MASTER_PASSWORD}
port        = 3306
host        = ${MYSQL_MASTER_HOST}
EOF

# 启动后等待5秒
echo "* Sleep 5s then Configure replication"
sleep 5
# 检查主库能否连接
mysql --defaults-file=/tmp/master.cnf -e "show databases;" > /dev/null 2>&1
if [ $? -eq 0 ];then
    # 判断主从是否配置，0：未配置，1：已配置
    if [ $(mysql --defaults-file=/tmp/slave.cnf -AN -e "show slave status;" | wc -l) -eq 0 ];then
        # 创建主从复制账户
        echo "* Create replication user"
        mysql --defaults-file=/tmp/master.cnf -AN -e "GRANT FILE, SELECT, SHOW VIEW, LOCK TABLES, RELOAD, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO '${MYSQL_REPLICATION_USER}'@'%' IDENTIFIED BY '${MYSQL_REPLICATION_PASSWORD}';"
        mysql --defaults-file=/tmp/master.cnf -AN -e "FLUSH PRIVILEGES;"
        # 配置主从信息
        echo "* Configure replication Info"
        # mysql --defaults-file=/tmp/slave.cnf -AN -e "RESET MASTER;"
        MYSQL_MASTER_Position=$(eval "mysql --defaults-file=/tmp/master.cnf -e 'show master status \G' | awk '/Position/{print \$2}'")
        MYSQL_MASTER_FILE=$(eval "mysql --defaults-file=/tmp/master.cnf -e 'show master status \G' | awk '/File/{print \$2}'")
        mysql --defaults-file=/tmp/slave.cnf -e "STOP SLAVE;"
        mysql --defaults-file=/tmp/slave.cnf -e "RESET SLAVE;"
        mysql --defaults-file=/tmp/slave.cnf -e "CHANGE MASTER TO \
            MASTER_HOST='$MYSQL_MASTER_HOST', \
            MASTER_PORT=3306, \
            MASTER_USER='$MYSQL_REPLICATION_USER', \
            MASTER_PASSWORD='$MYSQL_REPLICATION_PASSWORD', \
            MASTER_LOG_FILE='$MYSQL_MASTER_FILE', \
            MASTER_LOG_POS=$MYSQL_MASTER_Position;"
        mysql --defaults-file=/tmp/slave.cnf -e "START SLAVE;"

        # 检查主从状态，失败直接退出
        # mysql -uroot -p${MYSQL_ROOT_PASSWORD} -AN -e "show slave status\G"
        echo "* Check Replication healthy."
        counter=0
        while ! check_slave_health; do
            if (( counter >= 10 )); then
                echo "* Replication not healthy, health timeout reached, failing."
                break
                exit 1
            fi
            let counter=counter+1
            sleep 1
        done
    fi
else
    exit 1
fi
# 安全考虑，取消主库相关信息以及临时文件
unset MYSQL_MASTER_HOST MYSQL_MASTER_PASSWORD
rm -rf /tmp/master.cnf /tmp/slave.cnf
echo "* MySQL Replicate Done."