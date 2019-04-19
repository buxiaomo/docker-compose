# 设置ELK运行主机
```
docker node update --label-add elk=true Docker
```

# 配置内核参数（elk节点，如上Docker-Work01、Docker-Work02、Docker-Work03折三个节点需要设置）
```
cat > /etc/sysctl.d/elasticsearch.conf << EOF
vm.max_map_count = 262144
fs.file-max = 65536
EOF
sysctl -p /etc/sysctl.d/elasticsearch.conf
```

# 配置资源限制参数，elk用户是Elasticsearch运行的用户（elk节点，如上Docker-Work01、Docker-Work02、Docker-Work03折三个节点需要设置）
```
cat > /etc/security/limits.d/elasticsearch.conf << EOF
elk soft memlock unlimited
elk hard memlock unlimited
EOF
echo "*          soft    nproc     4096" > /etc/security/limits.d/20-nproc.conf
```

# 修改数据目录所有者（共享存储）
```
chown -R  1000:1000 data/elasticsearch data/logstash
```

# 部署
```
docker network create -d overlay elk
docker stack deploy -c elk.yml elk
```

# filebeat
```
src: https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.1-linux-x86_64.tar.gz
deb: https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.1-amd64.deb
rpm: https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.1-x86_64.rpm
```