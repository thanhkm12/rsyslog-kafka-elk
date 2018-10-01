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
                                 while, logrotate nginx log create new logs file. Rsyslog not detect offset curent,
                                 current offset of rsyslog different offset of file log. Option reopenOnTruncate="on" tells rsyslog to reopen input file when it was truncated (inode unchanged but file size on disk is less than current offset in memory).
                                 Example: [root@cache06 ~]# cat /var/lib/rsyslog/imfile-state:16646217
{ "filename": "\/var\/log\/nginx\/playstats\/st.fptplay.net.json.log", "prev_was_nl": 0, "curr_offs": 11145894890, "strt_offs": 11145894890 }

Detail: rsyslog imfile fails to detect log rotation #https://github.com/rsyslog/rsyslog/issues/2659

main_queue(
  queue.size="2000000"   # capacity of the main queue
)

if( $syslogtag == 'st_fplay')  then {
   action(
        name="log-to-kafka"
        broker=["183.80.199.4:9092","183.80.199.5:9092","118.69.190.39:9092"]
        type="omkafka"
        topic="st_fplay"
        Partitions.Auto="on"
        resubmitOnFailure="on"
        KeepFailedMessages="on"
        failedMsgFile="/etc/rsyslog.d/file-failed/file.log"
        template="FileFormat"
        closeTimeout="60000"
        queue.size="2000000"
        queue.saveonshutdown="on"
        queue.type="FixedArray"
        action.resumeRetryCount="-1"
        action.resumeInterval="60"
        action.reportSuspension="on"
        action.reportSuspensionContinuation="on"
        errorFile="/var/log/rsyslog-kafka-error.json"
   )
}
)

1.5. Configuration monitoring Rsyslog-ES-Kibana
vim /etc/rsyslog.d/monitor.conf

module(load="mmnormalize")
module(load="omelasticsearch")
module(load="impstats"
    interval="10"
    resetCounters="on"
    format="json-elasticsearch"
    ruleset="stats")

  template(name="rsyslog_stats" type="list") {
    constant(value="{")
    constant(value="\"@timestamp\":\"")
    property(name="timereported" dateFormat="rfc3339")
    constant(value="\",\"host\":\"")
    property(name="hostname")
    constant(value="\",")
    property(name="$!all-json" position.from="2")
  }
  ruleset(name="stats"){
    action(
      name="parse_rsyslog_stats"
      type="mmnormalize"
      ruleBase="/etc/rsyslog-json.rulebase")

    action(
      name="push_rsyslog_stats"
      type="omelasticsearch"
      server="210.245.125.152"
      serverport="9200"
      template="rsyslog_stats"
      searchIndex="stats-index"
      bulkmode="on"
      action.resumeRetryCount="-1"
      #action.resumeInterval="60"
      errorFile="/var/log/error-stats.log")
  }
  
  vim /etc/rsyslog-json.rulebase
  
      rule=:%data:json%
  
  
  
  
