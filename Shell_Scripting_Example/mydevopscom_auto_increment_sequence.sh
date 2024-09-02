#!/bin/bash

seqval_log_storages=`psql -d cwafdb -t -c "select last_value from log_storages_id_seq where (last_value) in ( select max(id) from log_storages );" | sed 's/ //g'`

if [ -z "$seqval_log_storages" ]
then
      #echo "log_storages table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."log_storages_id_seq"', coalesce(max(id), 1)) from public."log_storages";"
else
      echo "log_storages table sequence aleady updated"
fi

seqval_cve_libs=`psql -d cwafdb -t -c "select last_value from cve_libs_id_seq where (last_value) in ( select max(id) from cve_libs );" | sed 's/ //g'`

if [ -z "$seqval_cve_libs" ]
then
      #echo "cve_libs table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."cve_libs_id_seq"', coalesce(max(id), 1)) from public."cve_libs";"
else
      echo "cve_libs table sequence aleady updated"
fi

seqval_cve_libs_to_rules=`psql -d cwafdb -t -c "select last_value from cve_libs_to_rules_id_seq where (last_value) in ( select max(id) from cve_libs_to_rules );" | sed 's/ //g'`

if [ -z "$seqval_cve_libs_to_rules" ]
then
      #echo "cve_libs_to_rules table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."cve_libs_to_rules_id_seq"', coalesce(max(id), 1)) from public."cve_libs_to_rules";"
else
      echo "cve_libs_to_rules table sequence aleady updated"
fi

#seqval_cve_links=`psql -d cwafdb -t -c "select last_value from cve_links_id_seq where (last_value) in ( select max(id) from cve_links );" | sed 's/ //g'`

#if [ -z "$seqval_cve_links" ]
#then
      #echo "cve_links table sequence is not updated"
#      psql -d cwafdb -t -c "select setval('public."cve_links_id_seq"', coalesce(max(id), 1)) from public."cve_links";"
#else
#      echo "cve_links table sequence aleady updated"
#fi

#seqval_cve_rules=`psql -d cwafdb -t -c "select last_value from cve_rules_id_seq where (last_value) in ( select max(id) from cve_rules );" | sed 's/ //g'`

#if [ -z "$seqval_cve_rules" ]
#then
      #echo "cve_rules table sequence is not updated"
#      psql -d cwafdb -t -c "select setval('public."cve_rules_id_seq"', coalesce(max(id), 1)) from public."cve_rules";"
#else
#      echo "cve_rules table sequence aleady updated"
#fi

seqval_cwaf_configs=`psql -d cwafdb -t -c "select last_value from cwaf_configs_id_seq where (last_value) in ( select max(id) from cwaf_configs );" | sed 's/ //g'`

if [ -z "$seqval_cwaf_configs" ]
then
      #echo "cwaf_configs table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."cwaf_configs_id_seq"', coalesce(max(id), 1)) from public."cwaf_configs";"
else
      echo "cwaf_configs table sequence aleady updated"
fi

seqval_cwaf_feedbacks=`psql -d cwafdb -t -c "select last_value from cwaf_feedbacks_id_seq where (last_value) in ( select max(id) from cwaf_feedbacks );" | sed 's/ //g'`

if [ -z "$seqval_cwaf_feedbacks" ]
then
      #echo "cwaf_feedbacks table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."cwaf_feedbacks_id_seq"', coalesce(max(id), 1)) from public."cwaf_feedbacks";"
else
      echo "cwaf_feedbacks table sequence aleady updated"
fi

seqval_cwaf_revisions=`psql -d cwafdb -t -c "select last_value from cwaf_revisions_id_seq where (last_value) in ( select max(id) from cwaf_revisions );" | sed 's/ //g'`

if [ -z "$seqval_cwaf_revisions" ]
then
      #echo "cwaf_revisions table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."cwaf_revisions_id_seq"', coalesce(max(id), 1)) from public."cwaf_revisions";"
else
      echo "cwaf_revisions table sequence aleady updated"
fi

seqval_cwaf_rules=`psql -d cwafdb -t -c "select last_value from cwaf_rules_id_seq where (last_value) in ( select max(id) from cwaf_rules );" | sed 's/ //g'`

if [ -z "$seqval_cwaf_rules" ]
then
      #echo "cwaf_rules table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."cwaf_rules_id_seq"', coalesce(max(id), 1)) from public."cwaf_rules";"
else
      echo "cwaf_rules table sequence aleady updated"
fi

seqval_cwaf_user_ips=`psql -d cwafdb -t -c "select last_value from cwaf_user_ips_id_seq where (last_value) in ( select max(id) from cwaf_user_ips );" | sed 's/ //g'`

if [ -z "$seqval_cwaf_user_ips" ]
then
      #echo "cwaf_user_ips table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."cwaf_user_ips_id_seq"', coalesce(max(id), 1)) from public."cwaf_user_ips";"
else
      echo "cwaf_user_ips table sequence aleady updated"
fi

seqval_cwaf_users=`psql -d cwafdb -t -c "select last_value from cwaf_users_id_seq where (last_value) in ( select max(id) from cwaf_users );" | sed 's/ //g'`

if [ -z "$seqval_cwaf_users" ]
then
      #echo "cwaf_users table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."cwaf_users_id_seq"', coalesce(max(id), 1)) from public."cwaf_users";"
else
      echo "cwaf_users table sequence aleady updated"
fi

seqval_local_accounts=`psql -d cwafdb -t -c "select last_value from local_accounts_id_seq where (last_value) in ( select max(id) from local_accounts );" | sed 's/ //g'`

if [ -z "$seqval_local_accounts" ]
then
      #echo "local_accounts table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."local_accounts_id_seq"', coalesce(max(id), 1)) from public."local_accounts";"
else
      echo "local_accounts table sequence aleady updated"
fi

seqval_vendor_user_ips=`psql -d cwafdb -t -c "select last_value from vendor_user_ips_id_seq where (last_value) in ( select max(id) from vendor_user_ips );" | sed 's/ //g'`

if [ -z "$seqval_vendor_user_ips" ]
then
      #echo "vendor_user_ips table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."vendor_user_ips_id_seq"', coalesce(max(id), 1)) from public."vendor_user_ips";"
else
      echo "vendor_user_ips table sequence aleady updated"
fi

seqval_vendor_users=`psql -d cwafdb -t -c "select last_value from vendor_users_id_seq where (last_value) in ( select max(id) from vendor_users );" | sed 's/ //g'`

if [ -z "$seqval_vendor_users" ]
then
      #echo "vendor_users table sequence is not updated"
      psql -d cwafdb -t -c "select setval('public."vendor_users_id_seq"', coalesce(max(id), 1)) from public."vendor_users";"
else
      echo "vendor_users table sequence aleady updated"
fi
