#!/bin/bash
set -ex

cat > /tmp/mysql.cnf << EOF
[client]
user        = root
password    = ${MYSQL_ROOT_PASSWORD}
port        = 3306
socket      = /var/run/mysqld/mysqld.sock
EOF

if [ -z $MYSQL_REPLICATION_USER ];then
	mysqladmin --defaults-file=/tmp/mysql.cnf ping
else
  mysql --defaults-file=/tmp/mysql.cnf -e "SHOW SLAVE STATUS\G" | grep -qs  "Slave_IO_Running: Yes"
  mysql --defaults-file=/tmp/mysql.cnf -e "SHOW SLAVE STATUS\G" | grep -qs  "Slave_SQL_Running: Yes"
  mysqladmin --defaults-file=/tmp/mysql.cnf ping
fi