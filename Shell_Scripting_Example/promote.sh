#!/usr/bin/env bash
set -e
set -u

PGBOUNCER_DATABASE_INI_NEW="/tmp/pgbouncer.database.ini"
PGBOUNCER_HOSTS="<%=@webhost%>"
DATABASES="<%=@pgdb%>"
BACKUPUSER="<%=@backupuser%>"
BACKUPSERVER="<%=@backupserver%>" 
BACKUPFQDN="<%=@backupfqdn%>"

# Pause pgbouncer
##for h in ${PGBOUNCER_HOSTS}
##do
##  for d in ${DATABASES}
##  do
##      psql -U postgres -h ${h} -p 5432 pgbouncer -tc "pause ${d}"
##  done
##done

# Promote server
sudo /usr/bin/pg_ctlcluster <%=@pgversion%> main promote

# Generate new config file for pgbouncer
echo -e "[databases]\n" > ${PGBOUNCER_DATABASE_INI_NEW}
for d in ${DATABASES}
do
  echo -e "${d}= host=$(hostname -f)\n" >> ${PGBOUNCER_DATABASE_INI_NEW}
done

# Copy new config file, reload and resume pgbouncer
for h in ${PGBOUNCER_HOSTS}
do
  for d in ${DATABASES}
  do
      rsync -a ${PGBOUNCER_DATABASE_INI_NEW} ${h}:/etc/pgbouncer/pgbouncer.database.ini
      ssh postgres@${h} 'sudo /etc/init.d/pgbouncer restart'
      ##rsync -a /tmp/database.yml sites@${h}:/home/sites/accounts.mydevops.com/config/database.yml
      ##ssh sites@${h} 'sudo /etc/init.d/nginx restart'
  done
done

# Copy backup file config and switch over the current db server's wals stream and base backup
##rsync -a /etc/postgresql/9.3/main/${BACKUPFQDN}.conf ${BACKUPUSER}@${BACKUPSERVER}:/etc/barman.d/
##ssh ${BACKUPUSER}@${BACKUPSERVER} "barman switch-xlog --force --archive ${BACKUPFQDN}"

rm ${PGBOUNCER_DATABASE_INI_NEW}
