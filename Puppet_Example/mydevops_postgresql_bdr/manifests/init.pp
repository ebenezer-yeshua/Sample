class mydevops_postgresql_bdr($prod=true, $backup=true, $retention_policy="RECOVERY WINDOW OF 6 WEEKS"){

if $prod {
    
    $package_name         = 'postgresql-bdr-9.4'
    $client_package_name  = 'postgresql-bdr-client-9.4'

     sudo::conf { 'postgres':
          ensure  => present,
          content => 'postgres ALL=(ALL) NOPASSWD: /usr/bin/pg_ctlcluster,/etc/init.d/repmgrd',
     }
   
    include mydevops_postgresql_bdr::pgconf
      
      $manage_recovery_conf = false
    
  } else {
    $package_name        = $postgresql::params::server_package_name
    $client_package_name = $postgresql::params::client_package_name
  }
  
  if $backup {
    
   mydevops_postgresql_bdr::backups{'backup':}
   
  }

  class{'postgresql::globals':
    version              => hiera('postgresql_version', '9.4'),
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
    address => '66.230.129.150/32',
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

  postgresql::server::pg_hba_rule{"local backups for pgdb":
    type => 'host',
    user => "backups",
    address => '127.0.0.1/32',
    database => 'all',
    auth_method => 'md5',
  }

  mydevops_firewall::service{"POSTGRES":
    ports => [5432]
  }
  
  include mydevops_telegraf::monitor
  telegraf::input{'postgresql':
    plugin_type => 'postgresql',
    options     => [{
      address => "postgres://${monitor_username}:${monitor_password}@localhost/postgres"
    }]

  }

class pgconf{

   $pgpackages = ['postgresql-bdr-9.4-bdr-plugin', 'postgresql-client-common', 'postgresql-common', 'barman', 'awscli']
   package { $pgpackages:
     ensure => present,
   }

  postgresql::server::config_entry{wal_level:
    value => 'logical'
  }
  postgresql::server::config_entry{shared_preload_libraries:
    value => 'bdr'
  }
  postgresql::server::config_entry{default_sequenceam:
    value => 'bdr'
  }
  postgresql::server::config_entry{track_commit_timestamp:
    value => 'on'
  }
  postgresql::server::config_entry{max_connections:
    value => '1000'
  }
  postgresql::server::config_entry{max_wal_senders:
    value => '10'
  }
  postgresql::server::config_entry{max_replication_slots:
    value => '10'
  }
  postgresql::server::config_entry{max_worker_processes:
    value => '10'
  }
  postgresql::server::config_entry{wal_keep_segments:
    value => '30'
  }
}

define bdr_basic($ipaddress, $cl_ipaddress){

  $cl_password = 'bdrsync123';
  $cl_username = 'bdrsync';

  postgresql::server::role{'bdrsync':
    createdb => false,
    createrole => true,
    superuser => true,
    replication => true,
    password_hash => postgresql_password($cl_username, $cl_password)
  }

  mydevops_postgresql_bdr::permit{"replication_bdrsync":
    dbuser     => 'bdrsync',
    dbname    => 'replication',
    dbauth   => 'trust',
    local    => true,
     allow   => [
      {
        address     => "${ipaddress}/32",
        description => "bdrsync user access to replication - master"
      },
      {
        address     => "${cl_ipaddress}/32",
        description => "bdrsync user access to replication - client"
      }
    ]
  }

   mydevops_postgresql_bdr::permit{"replication_postgres":
    dbuser   => 'postgres',
    dbname   => 'replication',
    dbauth   => 'trust',
     allow   => [
      {
        address     => "${ipaddress}/32",
        description => "posgres user access to replication - master"
      },
      {
        address     => "${cl_ipaddress}/32",
        description => "posgres user access to replication - client"
      }
    ]
  }  
  
  mydevops_firewall::permit{"permit BDR - ${name}":
    chain => "POSTGRES",
    address => $cl_ipaddress
  }
  
}

define bdr_database($password,$ipaddress,$cl_ipaddress,$cl_fqdn,$bdr_create,$bdr_join,$btree_gist_extension=true,$bdr_extension=true){

  postgresql::server::role{"${name}":
    password_hash => postgresql_password("${name}", $password),
    login         => true,
  }

  postgresql::server::database {"${name}":
  require => Postgresql::Server::Role["${name}"],
  } 

  mydevops_postgresql_bdr::permit{"replication_${name}":
    dbuser   => 'bdrsync',
    dbname   => "${name}",
    dbauth   => 'password',
     allow   => [
      {
        address     => "${ipaddress}/32",
        description => "${fqdn}-${name}"
      },
      {
        address     => "${cl_ipaddress}/32",
        description => "${cl_fqdn}-${name}"
      }
    ]
  }

mydevops_postgresql_bdr::permit{"Allow_${name}":
    dbuser   => "${name}",
    dbname   => "${name}",
    dbauth   => 'md5',
     allow   => [
      {
        address     => "127.0.0.1/32",
        description => "Localhost Allow"
      }
    ]
  }

if $btree_gist_extension {
    postgresql_psql{"btree_gist extension create - ${name}":
      command => "CREATE EXTENSION btree_gist",
      unless  => "SELECT * FROM pg_extension where extname='btree_gist'",
      db      => $name,
      require => [Class['postgresql::server::service'], Postgresql::Server::Database[$name]]
    }

  }
 if $bdr_extension {
    postgresql_psql{"bdr extension create - ${name}":
      command => "CREATE EXTENSION bdr",
      unless  => "SELECT * FROM pg_extension where extname='bdr'",
      db      => $name,
      require => [Class['postgresql::server::service'], Postgresql::Server::Database[$name]]
    }
  }

  if $bdr_create {
    postgresql_psql{"bdr create - ${name}":
      command => "SELECT bdr.bdr_group_create(local_node_name:='${fqdn}',node_external_dsn:='host=${ipaddress} dbname=${name} user=${cl_username} password=${cl_password}')",
      unless  => "SELECT node_sysid FROM bdr.bdr_nodes",
      db      => $name,
      require => [Class['postgresql::server::service'], Postgresql::Server::Database[$name]]
    }
  }

  if $bdr_join {
    postgresql_psql{"bdr join - ${name}":
      command => "SELECT bdr.bdr_group_join(local_node_name := '${fqdn}',node_external_dsn :='host=${ipaddress} dbname=${name} user=${cl_username} password=${cl_password}',join_using_dsn := 'host={$cl_ipaddress} dbname=${name} user=${cl_username} password=${cl_password}')",
      unless  => "SELECT node_sysid from bdr.bdr_nodes",
      db      => $name,
      require => [Class['postgresql::server::service'], Postgresql::Server::Database[$name]]
    }
  }
}

define permit($dbname, $dbuser, $dbauth, $allow=[], $local=false) {

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

   mydevops_firewall::permit {"${allowhash['description']} - ${dbname}":
      chain   => "POSTGRES",
      address => $allowhash['address'],
    }
  }
 }

define backups($server="76.9.2.134", $retention_policy="RECOVERY WINDOW OF 6 WEEKS") {
  
  $backups_password = 'daeth1sanaekooPhie6';
  postgresql::server::role{backups:
    password_hash => postgresql_password('backups', $backups_password),
    createrole    => true,
    superuser     => true
  }
  postgresql::server::pg_hba_rule{"backups from ${server}":
    type        => 'host',
    user        => "backups",
    address     => "${server}/32",
    database    => 'all',
    auth_method => 'md5',
  }
  include mydevops_firewall
  mydevops_firewall::permit{'ssh permit backup-whk1.mydevopscdn.com':
    chain   => ssh,
    address => "${server}"
  }
  postgresql::server::config_entry{archive_mode:
    value => 'on'
  }
  postgresql::server::config_entry{archive_command:
    value => "rsync -a %p barman@localhost:/var/lib/barman/localhost/incoming/%f"
  }

  ssh_authorized_key { 'barman@backup-whk1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC2ipg0r7wYJFKmBxXwADzAcEOwM4oZHX7P2mgtGfzu9yhrClMax4dljuKPCzmgjlB5BSqZWT0wJLwqflDGTFnUqVdV0PCB1TGGba5mfXA5+oR5Gf6uDjcD0DZVIBA4q6oK63HSRbYJ8pwM01x4+Pl2pnF58T9rdILnX43TRjVh7YAu/SxnepcyY3hDFZyPlIPRa9etOuqi66fGgtBAsDu2y7Hw4Kcuk24Lr7ifKlkI7jDLLVIMWAPcdKNRasYKqpyT7nQQ7Hwfrk4zt2Qpp7Le/skUzB4gvnmq6dyHzZ2JDTQdeqONAuqxbUlYiOuREvOxDe3vlzfgVU5fsyqRSB15',
    }
 }

  file { 'barmans3sync.c':
    path    => '/usr/local/bin/barmans3sync.c',
    ensure  => file,
    owner   => 'barman',
    group   => 'barman',
    mode    => '0775',
    content => template('mydevops_postgresql_bdr/barmans3sync.c.erb'),
  }
  exec { 'barmans3sync':
    cwd      => '/usr/local/bin',
    path     => '/usr/bin:/usr/sbin:/bin',
    provider => shell,
    command  => 'gcc -o barmans3sync barmans3sync.c',
    unless   => '/usr/bin/test -e /usr/local/bin/barmans3sync',
   }~>
  file { 'barmans3sync':
    path    => '/usr/local/bin/barmans3sync',
    ensure  => file,
    owner   => 'barman',
    group   => 'barman',
    mode    => '0775',
  }  

  file { 'deleteolds3files.sh':
    path    => '/usr/local/bin/deleteolds3files.sh',
    ensure  => file,
    owner   => 'barman',
    group   => 'barman',
    mode    => '0775',
    content => template('mydevops_postgresql_bdr/deleteolds3files.sh.erb'),
  }

  file { 'localhost.conf':
    path    => '/etc/barman.d/localhost.conf',
    ensure  => file,
    owner   => 'barman',
    group   => 'barman',
    mode    => '0775',
    content => template('mydevops_postgresql_bdr/localhost.conf.erb'),
  }

  file { 'endpoints.json':
    path    => '/usr/lib/python3/dist-packages/botocore/data/endpoints.json',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode => '0775',
    content => template('mydevops_postgresql_bdr/endpoints.json.erb'),
  }

  file { '/var/lib/barman/.aws':
    ensure  => 'directory',
    owner   => 'barman',
    group   => 'barman',
    mode    => '0755',
  }

  file { 'config':
    path    => '/var/lib/barman/.aws/config',
    ensure  => file,
    owner   => 'barman',
    group   => 'barman',
    mode    => '0755',
    content => template('mydevops_postgresql_bdr/aws_client_config.erb'),
  }

  file { 'credentials':
    path    => '/var/lib/barman/.aws/credentials',
    ensure  => file,
    owner   => 'barman',
    group   => 'barman',
    mode    => '0755',
    content => template('mydevops_postgresql_bdr/aws_client_credentials.erb'),
  }

  postgresql_psql{"pgespresso extension create - postgres":
    command => "CREATE EXTENSION pgespresso",
    unless  => "SELECT * FROM pg_extension  where extname='pgespresso'",
    db      => 'postgres',
    require => [Class['postgresql::server::service']]
  }

  cron::job { 'pg-backup':
    minute      => '0',
    hour        => '2',
    date        => '*',
    month       => '*',
    weekday     => '*',
    user        => 'barman',
    command     => 'barmans3sync /var/lib/barman/localhost/base/ >/dev/null',
    environment => [ 'PATH="/usr/local/bin::/usr/bin:/bin"', ],
  }

 cron::job { 's3-deleteoldfiles':
  minute      => '0',
  hour        => '1',
  date        => '*',
  month       => '*',
  weekday     => '*',
  user        => 'barman',
  command     => 'sh /usr/local/bin/deleteolds3files.sh >/dev/null',
  environment => [ 'PATH="/usr/local/bin::/usr/bin:/bin"', ],
  }
}
