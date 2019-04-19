#!/bin/bash
# 删除服务
if [ $(docker stack ls | grep -E ^splunk | wc -l) != 0 ];then
    docker stack rm splunk
    sleep 5
fi

# 清理数据文件
HOST_LIST=(
    'root@10.0.3.51'
    'root@10.0.3.52'
    'root@10.0.3.53'
)

for HOST in ${HOST_LIST[*]};
do
    ssh ${HOST} 'rm -rf /opt/splunk/etc /opt/splunk/var'
    ssh ${HOST} 'mkdir -p /opt/splunk/etc /opt/splunk/var'
done

docker stack deploy -c splunk_cluster.yml splunk

ECHO=0
while true
do
    N=$(docker service logs splunk_master 2> /dev/null | grep "Waiting for web server at" 2> /dev/null | wc -l)
    if [[  ${N} -ge 2 ]]; then
        break
    else
        if [[  ${ECHO} -eq 0 ]]; then
            echo "Wait for the splunk server initialization to complete."
            ECHO=1
        fi
    fi
    sleep 1
done
sleep 5
docker service scale splunk_indexer01=1 splunk_indexer02=1 -d