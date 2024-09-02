class mydevops_blog::staging_db($blogdb=true) {

 if $blogdb {
    
    $package_name         = 'postgresql-9.3'
    $client_package_name  = 'postgresql-client-9.3'
  
    include mydevops_blog::staging_db::blogdb
    
    $manage_recovery_conf = false

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

 $repmgrpackage = ['postgresql-9.3-repmgr','repmgr-common']
   package { $repmgrpackage:
    ensure => present,
  }

}

class mydevops_blog::staging_db::blogdb{

  postgresql::server::config_entry{wal_level:
    value => 'archive'
  }
  postgresql::server::config_entry{checkpoint_segments:
    value => '8'
  }
  postgresql::server::config_entry{max_wal_senders:
    value => '3'
  }
  postgresql::server::config_entry{wal_keep_segments:
    value => '8'
  }
  postgresql::server::config_entry{hot_standby:
    value => 'off'
  }
}

  define mydevops_blog::staging_db::database($password, $user, $permit=[], $local=false, $db=false, $db_join=false, $db_create=false, $pgauth) {
  postgresql::server::db{$name:
    password  => $password,
    user      => $user
  }

  if $db {
    mydevops_blog::staging_db::db_database{$name:
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

define mydevops_blog::staging_db::permit($dbname, $dbuser, $dbauth, $allow=[], $local=false) {

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

define mydevops_blog::staging_db::role($dbrole, $dbpassword, $addgrant=[]) {

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

