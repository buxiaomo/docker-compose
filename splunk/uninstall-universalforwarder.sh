#!/bin/bash
HOST_LIST=(
    'root@10.3.236.30'
    'root@10.3.236.31'
    'root@10.3.236.32'
    'root@10.3.236.33'
    'root@10.3.236.34'
    'root@10.3.236.35'
    'root@10.3.236.38'
    'root@10.3.236.39'
    'root@10.3.236.40'
    'root@10.3.236.50'
    'root@10.3.236.51'
    'root@10.3.236.52'
    'root@10.3.236.41'
)

case $1 in
    install )
        for HOST in ${HOST_LIST[*]};
        do
            ssh ${HOST} 'rm -rf /opt/universalforwarder'
            ssh ${HOST} 'mkdir -p /opt/universalforwarder/etc /opt/universalforwarder/var'
        done
        docker stack deploy -c universalforwarder.yml splunk
    ;;
    rm )
        docker service rm splunk_uf
    ;;
    uninstall )
        docker service rm splunk_uf
        sleep 5
        for HOST in ${HOST_LIST[*]};
        do
            ssh ${HOST} 'rm -rf /opt/universalforwarder'
            ssh ${HOST} 'mkdir -p /opt/universalforwarder/etc /opt/universalforwarder/var'
        done
        docker stack deploy -c universalforwarder.yml splunk
    ;;
    * )
      echo "$0 install|uninstall|rm"
    ;;
esac
