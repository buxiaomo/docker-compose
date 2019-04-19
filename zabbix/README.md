# 添加zabbix组

```
docker node update --label-add zabbix=true Docker-Work03
docker node update --label-add zabbix=true Docker-Work04
```

# 部署应用

```
docker stack deploy -c zabbix.yml zabbix
```

# 部署Agent
```
wget https://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.0-1+xenial_all.deb
dpkg -i zabbix-release_3.0-1+xenial_all.deb
apt update
apt-get install zabbix-agent -y

# Server设置为本机IP地址
sed -i "s/^Server=.*/Server=10.0.3.13,10.0.3.14/g" /etc/zabbix/zabbix_agentd.conf
# ServerActive设置为zabbix service会运行的主机IP
sed -i "s/^ServerActive=.*/ServerActive=10.0.3.13,10.0.3.14/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Hostname=.*/Hostname=Docker04/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^#.UnsafeUserParameters=.*/UnsafeUserParameters=1/g" /etc/zabbix/zabbix_agentd.conf
systemctl start zabbix-agent.service
systemctl enable zabbix-agent.service
systemctl restart zabbix-agent.service
```