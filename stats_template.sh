curl -XPUT localhost:9200/_template/stats01 -d '
{
   "template":"stats*",
   "settings":{
      "number_of_shards":2,
      "number_of_replicas":0,
      "index":{
         "refresh_interval":"1s",
         "similarity":{
            "default":{
               "type":"classic"
            }
         }
      }
   },
  "mappings" : {
      "my_type" : {
        "dynamic_templates" : [
          {
            "strings" : {
              "match_mapping_type" : "string",
              "mapping" : {
                "fields" : {
                  "raw" : {
                    "ignore_above" : 256,
                    "type" : "keyword"
                  }
                },
                "type" : "keyword"
              }
            }
          }
        ]
      },
      "events" : {
        "properties" : {
          "@timestamp" : {
            "type" : "date"
          },
          "data" : {
            "properties" : {
              "acked" : {
                "type" : "long"
              },
              "discarded!full" : {
                "type" : "long"
              },
              "discarded!nf" : {
                "type" : "long"
              },
              "enqueued" : {
                "type" : "long"
              },
              "errors_auth" : {
                "type" : "long"
              },
              "errors_broker_down" : {
                "type" : "long"
              },
              "errors_other" : {
                "type" : "long"
              },
              "errors_timed_out" : {
                "type" : "long"
              },
              "errors_transport" : {
                "type" : "long"
              },
              "failed" : {
                "type" : "long"
              },
              "failed!checkConn" : {
                "type" : "long"
              },
              "failed!es" : {
                "type" : "long"
              },
              "failed!http" : {
                "type" : "long"
              },
              "failed!httprequests" : {
                "type" : "long"
              },
              "failures" : {
                "type" : "long"
              },
              "failures_msg_too_large" : {
                "type" : "long"
              },
              "failures_other" : {
                "type" : "long"
              },
              "failures_queue_full" : {
                "type" : "long"
              },
              "failures_unknown_partition" : {
                "type" : "long"
              },
              "failures_unknown_topic" : {
                "type" : "long"
              },
              "full" : {
                "type" : "long"
              },
              "inblock" : {
                "type" : "long"
              },
              "int_latency_avg_usec" : {
                "type" : "long"
              },
              "majflt" : {
                "type" : "long"
              },
              "maxoutqsize" : {
                "type" : "long"
              },
              "maxqsize" : {
                "type" : "long"
              },
              "maxrss" : {
                "type" : "long"
              },
              "minflt" : {
                "type" : "long"
              },
              "name" : {
                "type" : "keyword",
                "fields" : {
                  "keyword" : {
                    "type" : "keyword",
                    "ignore_above" : 256
                  }
                }
              },
              "nivcsw" : {
                "type" : "long"
              },
              "nvcsw" : {
                "type" : "long"
              },
              "openfiles" : {
                "type" : "long"
              },
              "origin" : {
                "type" : "keyword",
                "fields" : {
                  "keyword" : {
                    "type" : "keyword",
                    "ignore_above" : 256
                  }
                }
              },
              "oublock" : {
                "type" : "long"
              },
              "processed" : {
                "type" : "long"
              },
              "response!bad" : {
                "type" : "long"
              },
              "response!badargument" : {
                "type" : "long"
              },
              "response!bulkrejection" : {
                "type" : "long"
              },
              "response!duplicate" : {
                "type" : "long"
              },
              "response!other" : {
                "type" : "long"
              },
              "response!success" : {
                "type" : "long"
              },
              "resumed" : {
                "type" : "long"
              },
              "rtt_avg_usec" : {
                "type" : "long"
              },
              "size" : {
                "type" : "long"
              },
              "stime" : {
                "type" : "long"
              },
              "submitted" : {
                "type" : "long"
              },
              "suspended" : {
                "type" : "long"
              },
              "suspended!duration" : {
                "type" : "long"
              },
              "throttle_avg_msec" : {
                "type" : "long"
              },
              "topicdynacache!evicted" : {
                "type" : "long"
              },
              "topicdynacache!miss" : {
                "type" : "long"
              },
              "topicdynacache!skipped" : {
                "type" : "long"
              },
              "utime" : {
                "type" : "long"
              },
              "values" : {
                "type" : "object"
              }
            }
          },
          "host" : {
            "type" : "keyword",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          }
        }
      }
    }
}'
