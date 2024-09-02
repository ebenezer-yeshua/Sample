#!/bin/bash

SHOSTNAME=$(hostname | sed -e 's/[0-9]$//g')
DUMPPATH="/opt/dumps"
PG='9.3'
BACKUP=
USER=postgres
f=${2}

DATE=$(date +%F)
TARGZ=blog_basedump_pgsql-${PG}_${DATE}.tar.gz

test -d /etc/eselect/postgresql && \
{ test -d /etc/eselect/postgresql/slots/${PG} || { echo "postgresql version \"${PG}\" isn't a valid choice"; exit 1; }; }

case ${PG} in
        10)
                name_offset=pg_walfile_name_offset
                WAL=pg_wal
        ;;
        *)
                name_offset=pg_xlogfile_name_offset
                WAL=pg_xlog
        ;;
esac


if [[ "1" = "1" ]];
then

        if [[ "all" = "all" ]];
        then
                { test -d /var/lib/postgresql/${PG} || { echo "I don't think postgresql version \"${PG}\" is a valid choice"; exit 1; }; }
                test -d /var/run/postgresql/${PG} && sock="-h /var/run/postgresql/${PG}"
                echo "drop table DBbackup" | psql ${sock} 2>&1 | grep -q "in a read-only transaction" && exit 0
                cat <<-EOT | /usr/bin/psql ${sock} 2>&1 | egrep -v "NOTICE:  pg_stop_backup complete, all required WAL segments have been archived|: file changed as we read it"
select file_name from ${name_offset}(pg_start_backup('weekly')) \g pg_backup_start-${PG}
\! (cd /var/lib/postgresql && stat -c %Y ${PG}/main/${WAL}/\$(egrep -o "[0-9A-F]{24}" ~/pg_backup_start-${PG}) > ~/stamp-${PG} && tar -ch \
        --exclude ${PG}/main/pgsql.trigger.5442 --exclude ${PG}/main/${WAL}/[0-9]\* --exclude ${PG}/main/${WAL}/archive_status/[0-9]\* \
        -f - ${PG}/main | pigz -c | \
        cat > ${DUMPPATH}/.${TARGZ})
select pg_stop_backup() \g pg_backup_stop-${PG}
EOT
        TOUCH=$(date -d @$(cat stamp-${PG}) +%Y%m%d%H%M.%S)
        mv -f ${DUMPPATH}/.${TARGZ} ${DUMPPATH}/${TARGZ} ; touch -t ${TOUCH} ${DUMPPATH}/${TARGZ}
        fi
fi
