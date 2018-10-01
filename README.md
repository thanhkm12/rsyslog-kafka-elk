# rsyslog-kafka-elk
Project contain configureation file for rsyslog-kafka-elk on Centos platform

Follow step by Step

1.1. Install rsyslog: install repo, install rsyslog: 

cd /etc/yum.repos.d/
wget http://rpms.adiscon.com/v8-stable/rsyslog.repo
yum install rsyslog

1.2. Install package dependenies:
yum install rsyslog-mmnormalize rsyslog-elasticsearch rsyslog-kafka rsyslog-mmjsonparse

1.3. Configuration Rsyslog.conf
//add loca0.none prevent don't saved message from /var/log/message. Because, Default Rsyslog saved messgase have been sended to /var/log/meessage 
*.info;mail.none;authpriv.none;cron.none;local0.none               /var/log/messages
//add line 
$MaxMessageSize 64k   // Fix error Sep 12 10:55:45 cache15.prod.hcm.fplay rsyslogd[49986]: message too long (22526) with configured size 8096, begin of message is: { "receive_time": "2018-09-12T10:55:45+07:00", "services": "playstats"


// Comment line below for don't send messeage nosie to destination system ( Kafka )
#ModLoad imuxsock
#ModLoad imklog 

1.4. Config /etc/rsyslog.d/*.conf . Here is input form file to output kafka

module(load="imfile" PollingInterval="10")
module(load="omkafka")


input(type="imfile"
      File="/var/log/nginx/playstats/st.fptplay.net.json.log"   // Input file logs
      Tag="st_fplay"
      freshStartTail="on"     // discard old log, only send message at its first start and process new only new log message
      reopenOnTruncate="on"   // fix error rsyslog don't send message to destination system.
                                 while, logrotate nginx log create new logs file. Rsyslog not detect offsetg curent,
                                 current offset of rsyslog different offset of file log. Option reopenOnTruncate="on" tells rsyslog to reopen input file when it was truncated (inode unchanged but file size on disk is less than current offset in memory).
)
