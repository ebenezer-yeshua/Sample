#!/bin/bash
backuppath='/opt/dumps'
dat=$(date +%F)
host=`hostname -f`
pairnode=`repmgr -f /etc/repmgr.conf cluster show  |  head -4 | cut -d'|' -f2 |  grep -v + | grep -v Name | grep -wv $host | sed -e 's/"//g'`
dumpnode=`repmgr -f /etc/repmgr.conf cluster show  |  head -5 | cut -d'|' -f2,4  |  grep -v + | grep -v Name | egrep  'db4|db5' | grep -wv '* running' | sed -e 's/running//g' | sed -e 's/|//g' | sed -e 's/ //g'`

function alertmail {
      /usr/bin/mail -s 'Mail from blog Live pgbackup script' noc@mydevops.net <<< "$1"
}

function backup {
    rm -rf ${backuppath}/blog_pgbackup_*.sql.gz
    pg_dumpall | gzip -v > ${backuppath}/blog_pgbackup_${dat}.sql.gz  
}

function basebackup {
    rm -rf ${backuppath}/blog_basedump_pgsql-9.3_*.tar.gz
   /bin/bash /usr/local/bin/pgbasebackup.sh 1>& ${backuppath}/basebackup.log
}

function multipartupload {
   /bin/bash /usr/local/bin/multipartupload.sh ${backuppath}/blog_pgbackup_${dat}.sql.gz blog_pgbackup  1>& ${backuppath}/multipartupload.log
}

function basemultipartupload {
   /bin/bash /usr/local/bin/basemultipartupload.sh ${backuppath}/blog_basedump_pgsql-9.3_${dat}.tar.gz blog_basedump_pgsql  1>& ${backuppath}/basemultipartupload.log
}

function rsync-backup {
   aws s3 sync /var/lib/postgresql s3://backupsblog/rsync-backup/${dat}  1>& ${backuppath}/rsync-backup.log
}

function deletes3walbackup {
    aws s3 ls s3://blog-backup/${host}/wals/ | awk '{print $2}' > ${backuppath}/wallog_list.txt
    wdatelimit=$(date -d "-2 month" +%Y%m%d)

    for s in `cat ${backuppath}/wallog_list.txt`
    do
    waldate=`aws s3 ls s3://blog-backup/${host}/wals/${s} | awk '{print $1}' | uniq | sort -u | tail -1 | sed -e 's/-//g'`

      if [ "$wdatelimit" -ge "$waldate" ]
      then
       aws s3 rm s3://blog-backup/${host}/wals/${s} --recursive
      else
       echo "skip"
      fi
    done
}

function deletes3rsyncbackup {
   aws s3 ls s3://backupsblog/rsync-backup/ | awk '{print $2}' | grep -v ':' | sed -e 's/\///g' >  ${backuppath}/rsync_list.txt
   rdatelimit=$(date -d "-1 week" +%Y%m%d)
   for s in `cat  ${backuppath}/rsync_list.txt`
   do
   rsyncdate=`aws s3 ls s3://backupsblog/rsync-backup/${s} | awk '{print $2}' | grep -v ':' | sed -e 's/\///g' | sed -e 's/-//g'`

     if [ "$rdatelimit" -ge "$rsyncdate" ]
     then
       aws s3 rm s3://backupsblog/rsync-backup/${s}/ --recursive
     else
       echo "skip"
     fi
   done
}

function deletes3dumpbackup {
    aws s3 ls s3://backupsblog/ | grep -v rsync | awk '{print $4}' >  ${backuppath}/dump_list.txt
    ddatelimit=$(date -d "-1 week" +%Y%m%d)
    for s in `cat  ${backuppath}/dump_list.txt`
    do
    dumpdate=`aws s3 ls s3://backupsblog/${s} | awk '{print $1}' | sed -e 's/-//g' | grep -v 'PRE'`

      if [ "$ddatelimit" -ge "$dumpdate" ]
      then
        aws s3 rm s3://backupsblog/${s}
      else
        echo "skip"
      fi  
    done
}

for j in $host
do
  node_status=`repmgr -f /etc/repmgr.conf cluster show  |  head -4 |  grep -w '* running' | cut -d'|' -f3 | sed -e 's/"//g'`
  host_check=`repmgr -f /etc/repmgr.conf cluster show  |  head -4 |  grep -w '* running' | cut -d'|' -f2 | sed -e 's/"//g'`

if [ "$node_status" == ' primary ' ] && [ "$host_check" == " $j " ] ; then
     echo "Backup initiated from primary node"
     basebackup
     alertmail 'Cam basedump_pgsql completed on primary node successfully'
     basemultipartupload
     alertmail 'Cam basedump_pgsql backup has been uploaded to Digital Ocean Spaces successfully'
 elif [ "$host" == "db1-blog-prod-virt-nyc3.belugacdn.com" ] ; then
     echo "Cam pg_dumpall initiated from standby node"
     backup
     alertmail 'Cam pg_dumpall completed on standby node successfully'
     multipartupload
     alertmail 'Cam pg_dumpal backup has been uploaded to Digital Ocean Spaces successfully'
     deletes3dumpbackup
  else
      echo "This node doesn't suitble for any backups"
  fi
  deletes3walbackup
done
