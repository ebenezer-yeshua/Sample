#!/bin/bash

  HOSTNAME=`hostname -a`
  BUCKETNAME="s3://backup-postgresql/${HOSTNAME}/base"
  aws s3 ls --recursive ${BUCKETNAME} |  grep -w backup.info | while read -r line;
       do
        createDate=`echo $line|awk '{print $1}'`
        createDate=`date -d"$createDate" +%s`
        olderThan=`date --date "7 days ago" +%s`
        if [[ $createDate -lt $olderThan ]]
           then
            fileName=`echo $line|cut -d'/' -f3`
            if [[ $fileName != "" ]]
            then
                    aws s3 rm ${BUCKETNAME}/$fileName --recursive
            fi
       fi

       done;
