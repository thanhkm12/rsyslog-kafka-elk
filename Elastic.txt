1. Install Elasticsearch

yum install https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.1.rpm

2. Configuration Elasticsearch

#vim /etc/elasticsearch/elasticsearch.yml

network.host: 0.0.0.0
bootstrap.system_call_filter: false
bootstrap.memory_lock: true

# modifile jvm option max, mix heapsize

-Xms8g
-Xmx8g

#Important System Configuration

- ulimit

elasticsearch   soft     memlock         unlimited
elasticsearch   hard     memlock         unlimited
elasticsearch    -       nofile          65536
*                -       nofile          65536
elasticsearch    -       nproc           2048
elasticsearch    -       memlock         unlimited

- Sysconfig file

vim /etc/sysconfig/elasticsearch

JAVA_HOME=/opt/java
MAX_OPEN_FILES=65536
MAX_LOCKED_MEMORY=unlimited
MAX_MAP_COUNT=262144

vim /usr/lib/systemd/system/elasticsearch.service
LimitMEMLOCK=infinity

- Reload units
  systemctl daemon-reload

- Restart Elasticsearch
  systemctl restart elasticsearch.service


3. Script template Elasticsearch for index monitor Rsyslog

- Run script template

   sh stats_template.sh


4. List index

root@transcode48:/rsyslog# curl -XGET localhost:9200/_cat/indices?v
health status index              uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   cms_articles       2540eq1cQb2A04sfyQw-tQ   1   0      66739         5640      1.4gb          1.4gb
green  open   stats-index        ZLA4bVhUQ6C3O1hoo8wpng   2   0   80257256            0     17.4gb         17.4gb
yellow open   startalk           IY8GZbZXSHm1oruNW9a1Vw   5   1      26708           91      1.8mb          1.8mb
green  open   es-index           7WfsjvXrScadi5VrLxqZ0w   5   0          0            0       650b           650b
yellow open   st-delay           eBw4zVsGTeOnIFoHr5pG7g   5   1      60477            0    106.2mb        106.2mb
green  open   startalk_v2        kt_VFUBqTdGU2X8ygKZ3Ww   1   0      26708         5985      1.3gb          1.3gb
green  open   my_index           KdtgxrR9TjO7IPy6Tfbxsg   1   0          4            0     13.5kb         13.5kb
yellow open   cms-articles-mongo 7WuClU2tTeSJg0TJ7gK89g   5   1      66739           80      3.5mb          3.5mb
yellow open   .kibana            QEu4ZIIdRSWvrktG9M5zHQ   1   1         87            1     95.8kb         95.8kb
