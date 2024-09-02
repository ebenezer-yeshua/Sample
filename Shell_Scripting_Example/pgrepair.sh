#!/bin/bash
host=`hostname -f`
pgversion="<%=@pgversion%>"
pairnode=`repmgr -f /etc/repmgr.conf cluster show  |  head -4 | cut -d'|' -f2 |  grep -v + | grep -v Name | grep -wv $host | sed -e 's/"//g'`

function alertmail {
      /usr/bin/mail -s "Mail from $host pgrepair script" noc@comodo.net <<< "$1"
}

function clone {
      repmgr -f /etc/repmgr.conf node service --action=stop --checkpoint
      ##mv /var/lib/postgresql/$pgversion/main /var/lib/postgresql/$pgversion/main_backup_by_clone_$(date +%F:%T)
      repmgr -h $1 -U repmgr -d repmgr -f /etc/repmgr.conf --force --fast-checkpoint standby clone
      sudo /usr/bin/pg_ctlcluster $pgversion main start
      repmgr -f /etc/repmgr.conf standby register --force
}

function rejoin {
      repmgr -f /etc/repmgr.conf node service --action=stop --checkpoint
      repmgr -f /etc/repmgr.conf -d "host=$1 user=repmgr dbname=repmgr" node rejoin
      sudo  /etc/init.d/repmgrd restart
}

function cleanup {
      find /var/lib/postgresql/$pgversion/ -type d -name 'main_backup__by_clone_*' -mtime +10 -delete
}

for i in $pairnode
do
   upstream_check=`repmgr -f /etc/repmgr.conf cluster show  |  head -4 | cut -d'|' -f2,5 | grep -v + | grep -w $i | cut -d'|' -f2 | sed -e 's/"//g'`
   name_check=`repmgr -f /etc/repmgr.conf cluster show  |  head -4 | cut -d'|' -f2 |  grep -v + | grep -w $i |  sed -e 's/"//g'`
   role_check=`repmgr -f /etc/repmgr.conf cluster show  |  head -4|  cut -d'|' -f2,3 | grep -v + | grep -w $i | cut -d'|' -f2`
   status_check=`repmgr -f /etc/repmgr.conf cluster show  | head -4  | cut -d'|' -f2,3,4 | grep -v + | grep -w $i | cut -d'|' -f3 | grep -v Status`
   pairnode_status=`ssh postgres@$i "repmgr -f /etc/repmgr.conf cluster show  | head -4  | cut -d'|' -f2,3,4 | grep -v + | grep -w $i | cut -d'|' -f3"`   
   pairnode_role=`ssh postgres@$i "repmgr -f /etc/repmgr.conf cluster show  | head -4  | cut -d'|' -f2,3,4 | grep -v + | grep -w $i | cut -d'|' -f2"`

   if [ "$name_check" == "$pairnode" ]; then
    echo "Pair node name verified"
     if [ "$role_check" == ' standby ' ] && [ "$status_check" == ' ! running as primary ' ] ; then
        echo "Role and Status verified"
           if [ "$pairnode_status"  == ' * running ' ] && [ "$pairnode_role" == ' primary '  ]; then
             echo "Pair node Role and Status verified"
             echo "Clone process initiated"
             alertmail 'Clone process initiated on secondary db server'
             clone $i
             echo "Clone process finished"
             alertmail 'Clone process finished on secondary db server'
             cleanup
           else
             echo "Pair node Role and Status mismatch"
           fi
     else
         echo "Role and Status mismatch"
     fi
   else
    echo "Pair node name mismatch"
   fi
done

for j in $host
do
  node_status=`repmgr -f /etc/repmgr.conf cluster show  |  head -4 |  grep -w '! running' | cut -d'|' -f3 | sed -e 's/"//g'`
  host_check=`repmgr -f /etc/repmgr.conf cluster show  |  head -4 |  grep -w '! running' | cut -d'|' -f2 | sed -e 's/"//g'`

  if [ "$node_status" == ' standby ' ] && [ "$host_check" == " $j " ] ; then
     echo "Standy node need to rejoin with primary node"
     rejoin $pairnode
     alertmail 'Standby node rejoined with primary node sucessfully'
  else
     echo "Stanby node seems fine"
  fi
done