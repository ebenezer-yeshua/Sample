class mydevops_blog::doprod_db($blogdb=true, $nodeid=undef, $nodename=undef, $webhost=undef, $pgdb=undef, $pgversion='9.3') {

 if $blogdb {
    
    $package_name         = 'postgresql-9.3'
    $client_package_name  = 'postgresql-client-9.3'

     sudo::conf { 'postgres':
          ensure  => present,
          content => 'postgres ALL=(ALL) NOPASSWD: /usr/bin/pg_ctlcluster,/etc/init.d/repmgrd',
     }
   
      include mydevops_blog::doprod_db::blogdb

      mydevops_blog::doprod_db::blogdb::repmgr{'repmgr.conf':
            nodeid     => $nodeid,
            nodename   => $nodename,
            repmgruser => 'repmgr',
            repmgrdb   => 'repmgr',
            pgversion  => $pgversion
      }
      mydevops_blog::doprod_db::blogdb::promote{'promote.sh':
            webhost => $webhost,
            pgdb => $pgdb,
            pgversion => $pgversion,
            backupuser => 'barman',
            backupserver => 'backup-whk1.mydevopscdn.com',
            backupfqdn => 'db-blog-prod-virt.mydevopscdn.com'
      }
      mydevops_blog::doprod_db::blogdb::dbconfig{'database.yml':
           dbserver => $fqdn,
      }
      mydevops_blog::doprod_db::blogdb::backup{'db-blog-prod-virt.mydevopscdn.com.conf':
            pgserver => $fqdn,
            backupuser => 'backups',
            backuppass => 'daeth1sanaekooPhie6'
      }
      
      $manage_recovery_conf = true
    
  } else {
    $package_name        = $postgresql::params::server_package_name
    $client_package_name = $postgresql::params::client_package_name
  }
  
  class{'postgresql::globals':
    version              => hiera('postgresql_version', '9.3'),
    server_package_name  => $package_name,
    client_package_name  => $client_package_name,
    manage_recovery_conf => $manage_recovery_conf
  }
  
  class{'postgresql::server':
    listen_addresses     => '*',
    pg_hba_conf_defaults => false,
  }

  postgresql::server::pg_hba_rule {"local - root":
    type        => 'local',
    database    => 'all',
    user        => 'root',
    auth_method => 'md5',
  }
  
  postgresql::server::pg_hba_rule {"local - postgres":
    type        => 'local',
    database    => 'all',
    user        => 'postgres',
    auth_method => 'ident',
  }
  
  postgresql::server::role{root:
    password_hash => 'md51bc31ee8732f88a439e18a36a0244aad',
    createrole    => true,
    superuser     => true
  }

  $monitor_password = 'koh1moh8iech3euMiaf';
  $monitor_username = 'monitor';
  postgresql::server::role{monitor:
    password_hash => postgresql_password($monitor_username, $monitor_password),
    createrole => true,
    superuser => true
  }

  postgresql::server::pg_hba_rule{"monitoring from nagios":
    type => 'host',
    user => "monitor",
    address => '10.0.1.150/32',
    database => 'all',
    auth_method => 'md5',
  }

  postgresql::server::pg_hba_rule{"monitoring from nagios1-ewr1":
    type => 'host',
    user => "monitor",
    address => '10.0.1.170/32',
    database => 'all',
    auth_method => 'md5',
  }
  
  postgresql::server::pg_hba_rule{"monitoring from nagios2-ewr1":
    type => 'host',
    user => "monitor",
    address => '10.0.1.174/32',
    database => 'all',
    auth_method => 'md5',
  }

  postgresql::server::pg_hba_rule{"local monitor for telegraf":
    type => 'host',
    user => "monitor",
    address => '127.0.0.1/32',
    database => 'all',
    auth_method => 'md5',
  }  
  
  include mydevops_telegraf::monitor
  telegraf::input{'postgresql':
    plugin_type => 'postgresql',
    options     => [{
      address => "postgres://${monitor_username}:${monitor_password}@localhost/postgres"
    }]
  }

  $repmgrpackage = ['postgresql-9.3-repmgr','repmgr-common','postgresql-9.3-pgespresso','postgresql-server-dev-9.3','libpq-dev']
   package { $repmgrpackage:
    ensure => present,
  }

}

class mydevops_blog::doprod_db::blogdb{

$server = 'backup-whk1.mydevopscdn.com'

if ($fqdn == 'db4-blog-prod-virt-sjc3.mydevopscdn.com') or ($fqdn == 'db5-blog-prod-virt-sjc3.mydevopscdn.com') or ($fqdn == 'db3-blog-prod-virt-nyc3.mydevopscdn.com')
{
  postgresql::server::config_entry{wal_level:
    value => 'hot_standby'
  }
  postgresql::server::config_entry{checkpoint_segments:
    value => '64'
  }
  postgresql::server::config_entry{max_wal_senders:
    value => '5'
  }
  postgresql::server::config_entry{wal_keep_segments:
    value => '3000'
  }
  postgresql::server::config_entry{hot_standby:
    value => 'on'
  }
  postgresql::server::config_entry{shared_preload_libraries:
    value => 'repmgr'
  }
  postgresql::server::config_entry{max_connections:
    value => '1024'
  }
  postgresql::server::config_entry{archive_mode:
    value => 'on'
  }
  postgresql::server::config_entry{archive_command:
    value => "barman-cloud-wal-archive -P barman-cloud s3://blog-backup ${fqdn} /var/lib/postgresql/9.3/main/pg_xlog/%f"
  }
  postgresql::server::config_entry{shared_buffers:
    value => '64256MB'
  }
  postgresql::server::config_entry{maintenance_work_mem:
    value => '2GB'
  }
  postgresql::server::config_entry{random_page_cost:
    value => '1.1'
  }
  postgresql::server::config_entry{log_autovacuum_min_duration:
    value => '500'
  }
  postgresql::server::config_entry{autovacuum_max_workers:
    value => '5'
  }
  postgresql::server::config_entry{autovacuum_naptime:
    value => '5min'
  }
  postgresql::server::config_entry{autovacuum_vacuum_threshold:
    value => '500'
  }
  postgresql::server::config_entry{autovacuum_analyze_threshold:
    value => '500'
  }
  postgresql::server::config_entry{autovacuum_vacuum_cost_limit:
    value => '100'
  }
  postgresql::server::config_entry{work_mem:
    value => '64256kB'
  }
  postgresql::server::config_entry{tcp_keepalives_idle:
    value => '25'
  }
  postgresql::server::config_entry{tcp_keepalives_interval:
    value => '25'
  }
  postgresql::server::config_entry{effective_cache_size:
    value => '192768MB'
  }
  postgresql::server::config_entry{checkpoint_completion_target:
    value => '0.9'
  }
  postgresql::server::config_entry{wal_buffers:
    value => '16MB'
  }
  postgresql::server::config_entry{effective_io_concurrency:
    value => '200'
  }
  postgresql::server::config_entry{default_statistics_target:
    value => '100'
  }
}
elsif ($fqdn == 'db1-blog-prod-virt-nyc3.mydevopscdn.com')
{
  postgresql::server::config_entry{wal_level:
    value => 'hot_standby'
  }
  postgresql::server::config_entry{checkpoint_segments:
    value => '64'
  }
  postgresql::server::config_entry{max_wal_senders:
    value => '5'
  }
  postgresql::server::config_entry{wal_keep_segments:
    value => '3000'
  }
  postgresql::server::config_entry{hot_standby:
    value => 'on'
  }
  postgresql::server::config_entry{max_connections:
    value => '1024'
  }
  postgresql::server::config_entry{archive_mode:
    value => 'off'
  }
  postgresql::server::config_entry{shared_buffers:
    value => '64256MB'
  }
  postgresql::server::config_entry{maintenance_work_mem:
    value => '2GB'
  }
  postgresql::server::config_entry{random_page_cost:
    value => '1.1'
  }
    postgresql::server::config_entry{log_autovacuum_min_duration:
    value => '500'
  }
  postgresql::server::config_entry{autovacuum_max_workers:
    value => '5'
  }
  postgresql::server::config_entry{autovacuum_naptime:
    value => '5min'
  }
  postgresql::server::config_entry{autovacuum_vacuum_threshold:
    value => '500'
  }
  postgresql::server::config_entry{autovacuum_analyze_threshold:
    value => '500'
  }
  postgresql::server::config_entry{autovacuum_vacuum_cost_limit:
    value => '100'
  }
  postgresql::server::config_entry{work_mem:
    value => '64256kB'
  }
  postgresql::server::config_entry{tcp_keepalives_idle:
    value => '25'
  }
  postgresql::server::config_entry{tcp_keepalives_interval:
    value => '25'
  }
  postgresql::server::config_entry{effective_cache_size:
    value => '192768MB'
  }
  postgresql::server::config_entry{checkpoint_completion_target:
    value => '0.9'
  }
  postgresql::server::config_entry{wal_buffers:
    value => '16MB'
  }
  postgresql::server::config_entry{effective_io_concurrency:
    value => '200'
  }
  postgresql::server::config_entry{default_statistics_target:
    value => '100'
  }
  postgresql::server::config_entry{max_standby_streaming_delay:
    value => '-1'
  }
  postgresql::server::config_entry{max_standby_archive_delay:
    value => '-1'
  }
  postgresql::server::config_entry{hot_standby_feedback:
    value => 'on'
  }
  postgresql::server::config_entry{wal_sync_method:
    value => 'fsync'
  }
  postgresql::server::config_entry{wal_writer_delay:
    value => '10000ms'
  }
  postgresql::server::config_entry{wal_receiver_timeout:
    value => '1000s'
  }
  postgresql::server::config_entry{wal_receiver_status_interval:
    value => '1000s'
  }
  mydevops_blog::doprod_db::blogdb::recovery{'recovery.conf':
  metapghost => 'db3-blog-prod-virt-nyc3.mydevopscdn.com',
  pghost => $fqdn,
  s3name => 'blog-backup',
  pgpath => 'db4-blog-prod-virt-sjc3.mydevopscdn.com'
  }
}
else
{
  notify { 'no fqdn match': }
}

 $backups_password = 'daeth1sanaekooPhie6'; 
 postgresql::server::role{backups:
    password_hash => postgresql_password('backups', $backups_password),
    createrole    => true,
    superuser     => true
  }
  postgresql::server::pg_hba_rule{"backups from ${server}":
    type        => 'host',
    user        => "backups",
    address     => '10.0.1.134/32',
    database    => 'all',
    auth_method => 'trust',
  }

define repmgr($pgversion, $nodeid, $nodename, $repmgruser, $repmgrdb) {
  file { 'repmgr.conf':
    path    => '/etc/repmgr.conf',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    notify  => Service['repmgrd'],
    content => template('mydevops_blog/repmgr.conf.erb'),
  }
  file { 'repmgrd.init':
    path    => '/etc/init.d/repmgrd',
    ensure  => file,
    content => template('mydevops_blog/repmgrd.init.erb'),
  }
  service { 'repmgrd':
    ensure => running,
   }
   file { 'repmgrd':
    path    => '/etc/default/repmgrd',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    notify  => Service['repmgrd'],
    content => template('mydevops_blog/repmgrd.erb'),
  }
   file { 'pgrepair.sh':
    path    => '/usr/local/bin/pgrepair.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_blog/pgrepair.sh.erb'),
  }
 }
 define dbconfig($dbserver) {
   file { 'database.yml':
    path    => '/tmp/database.yml',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_blog/database.yml.erb'),
  }
 }
 define promote($webhost, $pgversion, $pgdb, $backupserver, $backupuser, $backupfqdn) {
   file { 'promote.sh':
    path    => '/usr/local/bin/promote.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_blog/promote.sh.erb'),
  }
 }
 define backup($pgserver, $backupuser, $backuppass) {
   file { 'db-blog-prod-virt.mydevopscdn.com.conf':
    path    => '/etc/postgresql/9.3/main/db-blog-prod-virt.mydevopscdn.com.conf',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_blog/db-blog-prod-virt.mydevopscdn.com.conf.erb'),
  }
 }
 define recovery($metapghost, $pghost, $s3name, $pgpath) 
 {
  file { '/var/lib/postgresql/9.3/main/recovery.conf':
    ensure  => 'present',
    replace => 'yes', 
    content => template("mydevops_blog/recovery.conf.erb"),
    group   => 'postgres',
    owner   => 'postgres',
    mode    => '0644',
    notify  => Service['postgresql'],
  }
 }
}

  define mydevops_blog::doprod_db::database($password, $user, $permit=[], $local=false, $db=false, $db_join=false, $db_create=false, $pgauth) {
  postgresql::server::db{$name:
    password  => $password,
    user      => $user
  }

  if $db {
    mydevops_blog::prod_db::db_database{$name:
      password    => $password,
      db_join    => $db_join,
      db_create  => $db_create
    }
  }

  if $local {
    postgresql::server::pg_hba_rule {"local - ${name}":
      type        => 'local',
      database    => $name,
      user        => $user,
      auth_method => $pgauth,
    }
  }
  
  $permit.each |$hash| {
    postgresql::server::pg_hba_rule {"${hash['description']} - ${name}":
      type        => 'host',
      database    => $name,
      user        => $user,
      address     => $hash['address'],
      auth_method => $pgauth,
    }
  }
}

define mydevops_blog::doprod_db::permit($dbname, $dbuser, $dbauth, $allow=[], $local=false) {

  if $local {
    postgresql::server::pg_hba_rule {"local - ${dbname}":
      type        => 'local',
      database    => $dbname,
      user        => $dbuser,
      auth_method => $dbauth,
    }
  }

  $allow.each |$allowhash| {
    postgresql::server::pg_hba_rule {"${allowhash['description']} - ${dbname}":
      type        => 'host',
      database    => $dbname,
      user        => $dbuser,
      address     => $allowhash['address'],
      auth_method => $dbauth,
    }
  }
}

define mydevops_blog::doprod_db::role($dbrole, $dbpassword, $addgrant=[]) {

   postgresql::server::role { "$dbrole":
   password_hash => postgresql_password("$dbrole", "$dbpassword"),
  }

$addgrant.each |$addgranthash| {
postgresql::server::database_grant { "$addgranthash['db']":
   privilege => $addgranthash['privilege'],
   db        => $addgranthash['db'],
   role      => $addgranthash['role'],
  }
 }
}
