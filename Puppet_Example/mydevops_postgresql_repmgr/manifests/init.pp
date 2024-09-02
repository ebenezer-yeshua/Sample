class mydevops_postgresql_repmgr($production=true, $nodeid=undef, $nodename=undef, $webhost=undef, $pgdb=undef, $pgversion=undef) {

if $production {
    
    $package_name         = "postgresql-$pgversion"
    $client_package_name  = "postgresql-client-$pgversion"

     sudo::conf { 'postgres':
          ensure  => present,
          content => 'postgres ALL=(ALL) NOPASSWD: /usr/bin/pg_ctlcluster,/etc/init.d/repmgrd',
     }
   
      include mydevops_postgresql_repmgr::repmgrdb

      mydevops_postgresql_repmgr::repmgrdb::repmgr{'repmgr.conf':
            nodeid     => $nodeid,
            nodename   => $fqdn,
            repmgruser => 'repmgr',
            repmgrdb   => 'repmgr',
            pgversion  => $pgversion
      }
      mydevops_postgresql_repmgr::repmgrdb::promote{'promote.sh':
            webhost => $webhost,
            pgdb => $pgdb,
            pgversion => $pgversion,
            backupuser => 'barman',
            backupserver => 'backup-whk1.mydevopscdn.com',
            backupfqdn => $fqdn
      }
      mydevops_postgresql_repmgr::repmgrdb::backups{'backup server':
            backupserver  => '10.0.1.134',
            backupuser => 'backups',
            backuppass => '******',
            retention_policy => 'RECOVERY WINDOW OF 6 WEEKS'
      }
      mydevops_postgresql_repmgr::repmgrdb::pgrepair{'pg repair':
            pgversion => '11'
      }
      
      $manage_recovery_conf = true
    
  } else {
    $package_name        = $postgresql::params::server_package_name
    $client_package_name = $postgresql::params::client_package_name
  }
  
  class{'postgresql::globals':
    version              => hiera('postgresql_version', '11'),
    server_package_name  => $package_name,
    client_package_name  => $client_package_name,
    manage_recovery_conf => $manage_recovery_conf
  }

  class{'postgresql::server':
    listen_addresses => '*',
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
  
  postgresql::server::role{"repmgr":
    createdb => true,
    createrole => true,
    superuser => true
  }

  postgresql::server::db{"repmgr":
    password => '******',
    user => 'repmgr'
  }

  postgresql::server::role{root:
    password_hash => '*******',
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

  postgresql::server::pg_hba_rule{"Allow all local access":
    type => 'local',
    user => "all",
    database => 'all',
    auth_method => 'peer',
  }
  
  postgresql::server::pg_hba_rule{"Allow all local access by ipv4":
    type => 'host',
    user => "all",
    database => 'all',
    address => '127.0.0.1/32',
    auth_method => 'md5'
  }

  postgresql::server::pg_hba_rule{"Allow all local access by ipv6":
    type => 'host',
    user => "all",
    database => 'all',
    address => '::1/128',
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
    address => '162.255.24.174/32',
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

  $repmgrpackage = ["postgresql-$pgversion-repmgr","repmgr-common","barman","barman-cli-cloud","python3-barman", "awscli"]
   package { $repmgrpackage:
    ensure => present,
  }

  file { 'endpoints.json':
    path    => '/usr/lib/python3/dist-packages/botocore/data/endpoints.json',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode => '0775',
    content => template('mydevops_postgresql_repmgr/endpoints.json.erb'),
  }

  file { '/var/lib/postgresql/.aws':
    ensure  => 'directory',
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0755',
  }

  file { 'config':
    path    => '/var/lib/postgresql/.aws/config',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0755',
    content => template('mydevops_postgresql_repmgr/aws_client_config.erb'),
  }

  file { 'credentials':
    path    => '/var/lib/postgresql/.aws/credentials',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0755',
    content => template('mydevops_postgresql_repmgr/aws_client_credentials.erb'),
  }

  file { 'deleteolds3files.sh':
    path    => '/usr/local/bin/deleteolds3files.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0755',
    content => template('mydevops_postgresql_repmgr/deleteolds3files.sh.erb'),
  }
}

class mydevops_postgresql_repmgr::repmgrdb{

$server = 'backup-whk1.mydevopscdn.com'

  postgresql::server::config_entry{wal_level:
    value => 'hot_standby'
  }
  postgresql::server::config_entry{max_wal_senders:
    value => '5'
  }
  postgresql::server::config_entry{wal_keep_segments:
    value => '1000'
  }
  postgresql::server::config_entry{hot_standby:
    value => 'on'
  }
  postgresql::server::config_entry{shared_preload_libraries:
    value => 'repmgr'
  }
  
define repmgr($pgversion, $nodeid, $nodename, $repmgruser, $repmgrdb) {
  file { 'repmgr.conf':
    path    => '/etc/repmgr.conf',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    notify  => Service['repmgrd'],
    content => template('mydevops_postgresql_repmgr/repmgr.conf.erb'),
  }
  file { 'repmgrd.init':
    path    => '/etc/init.d/repmgrd',
    ensure  => file,
    mode => '0775',
    content => template('mydevops_postgresql_repmgr/repmgrd.init.erb'),   
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
    content => template('mydevops_postgresql_repmgr/repmgrd.erb'),
  }
 }
 define pgrepair($pgversion) {
    file { 'pgrepair.sh':
    path    => '/usr/local/bin/pgrepair.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_postgresql_repmgr/pgrepair.sh.erb'),
  }
 } 
 define promote($webhost, $pgversion, $pgdb, $backupserver, $backupuser, $backupfqdn) {
   file { 'promote.sh':
    path    => '/usr/local/bin/promote.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_postgresql_repmgr/promote.sh.erb'),
  }
 }
 define backup($pgserver, $backupuser, $backuppass, $pgversion) {
   file { 'confluence-virt-ewr1.mydevopscdn.com.conf':
    path    => "/etc/postgresql/$pgversion/main/confluence-virt-ewr1.mydevopscdn.com.conf",
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_postgresql_repmgr/confluence-virt-ewr1.mydevopscdn.com.conf.erb'),
  }
 }
 define recovery($metapghost, $pghost, $s3name, $pgpath, $pgversion) 
 {
  file { "/var/lib/postgresql/$pgversion/main/recovery.conf":
    ensure  => 'present',
    replace => 'yes', 
    content => template("mydevops_postgresql_repmgr/recovery.conf.erb"),
    group   => 'postgres',
    owner   => 'postgres',
    mode    => '0644',
    notify  => Service['postgresql'],
  }
 }
 define backups($backupserver, $backupuser, $backuppass, $retention_policy) {

  postgresql::server::role{backups:
    password_hash => postgresql_password('backups', $backuppass),
    createrole    => true,
    superuser     => true
  }
  postgresql::server::pg_hba_rule{"backups from ${backupserver}":
    type        => 'host',
    user        => "${backupuser}",
    address     => "${backupserver}/32",
    database    => 'all',
    auth_method => 'md5',
  }

  mydevops_firewall::permit{'ssh permit backup-whk1.mydevopscdn.com':
    chain   => ssh,
    address => "${backupserver}"
  }
  postgresql::server::config_entry{archive_mode:
    value => 'on'
  }
  postgresql::server::config_entry{archive_command:
    value => "barman-cloud-wal-archive -P barman-cloud s3://backup-postgresql ${fqdn} /var/lib/postgresql/11/main/pg_wal/%f"
  }

  ssh_authorized_key { 'barman@backup-whk1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC2ipg0r7wYJFKmBxXwADzAcEOwM4oZHX7P2mgtGfzu9yhrClMax4dljuKPCzmgjlB5BSqZWT0wJLwqflDGTFnUqVdV0PCB1TGGba5mfXA5+oR5Gf6uDjcD0DZVIBA4q6oK63HSRbYJ8pwM01x4+Pl2pnF58T9rdILnX43TRjVh7YAu/SxnepcyY3hDFZyPlIPRa9etOuqi66fGgtBAsDu2y7Hw4Kcuk24Lr7ifKlkI7jDLLVIMWAPcdKNRasYKqpyT7nQQ7Hwfrk4zt2Qpp7Le/skUzB4gvnmq6dyHzZ2JDTQdeqONAuqxbUlYiOuREvOxDe3vlzfgVU5fsyqRSB15',
  }

  cron::job { 'pg-backup':
  minute      => '0',
  hour        => '2',
  date        => '*',
  month       => '*',
  weekday     => '*',
  user        => 'postgres',
  command     => 'barman-cloud-backup -P barman-cloud  s3://backup-postgresql `hostname -a` >/dev/null',
  environment => [ 'PATH="/usr/local/bin::/usr/bin:/bin"', ],
  }

  cron::job { 's3-deleteoldfiles':
  minute      => '0',
  hour        => '1',
  date        => '*',
  month       => '*',
  weekday     => '*',
  user        => 'postgres',
  command     => 'sh /usr/local/bin/deleteolds3files.sh >/dev/null',
  environment => [ 'PATH="/usr/local/bin::/usr/bin:/bin"', ],
  }

 }
}

define mydevops_postgresql_repmgr::database($password, $user, $permit=[], $local=false, $db=false, $db_join=false, $db_create=false, $pgauth=undef) {
  postgresql::server::db{$name:
    password  => $password,
    user      => $user
  }

  if $db {
    mydevops_postgresql_repmgr::db_database{$name:
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

define mydevops_postgresql_repmgr::permit($dbname, $dbuser, $dbauth, $allow=[], $local=false) {

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

define mydevops_postgresql_repmgr::role($dbrole, $dbpassword, $addgrant=[]) {

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
