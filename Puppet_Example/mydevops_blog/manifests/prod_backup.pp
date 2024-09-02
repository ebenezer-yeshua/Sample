class mydevops_blog::prod_backup($blogbackup=true) {

  if $blogbackup {

    include mydevops_blog::prod_backup::blogdbbackup

  } else {
    
     notify {'Cam backup setup has been disabled':}
  }

}

class mydevops_blog::prod_backup::blogdbbackup{

  $backuppackage = ['awscli', 'barman-cli']
  package { $backuppackage:
    ensure => present,
  }
  file { '/opt/multipart':
    ensure => 'directory',
    owner  => 'postgres',
    group  => 'postgres',
    mode => '0775',
  }
  file { '/opt/dumps':
    ensure => 'directory',
    owner  => 'postgres',
    group  => 'postgres',
    mode => '0775',
  }
  awscli::profile { 'barman-cloud':
    user                  => 'postgres',
    group                 => 'postgres',
    homedir               => '/var/lib/postgresql',
    aws_access_key_id     => 'SBCDHZFUKBANXNX33CL2',
    aws_secret_access_key => 'SLCJyCtaiyzX/O2oI9QXHQJhRqWsu7aeMANLCXFhVSE',
    aws_region            => 'us-gov-west-1',
    profile_name          => 'barman-cloud'
  }  
  awscli::profile { 'default':
    user                  => 'postgres',
    group                 => 'postgres',
    homedir               => '/var/lib/postgresql',
    aws_access_key_id     => 'DPC5FJBBEAT****',
    aws_secret_access_key => '4oiAspMKjOp***',
    aws_region            => 'us-gov-west-1',
  } 
  file { 'pgbackup.sh':
    path    => '/usr/local/bin/pgbackup.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_blog/pgbackup.sh.erb'),
  }
  file { 'pgbasebackup.sh':
    path    => '/usr/local/bin/pgbasebackup.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_blog/pgbasebackup.sh.erb'),
  }
  file { 'endpoints.json':
    path    => '/usr/lib/python3/dist-packages/botocore/data/endpoints.json',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode => '0644',
    content => template('mydevops_blog/endpoints.json.erb'),
  }
   file { 'multipartupload.sh':
    path    => '/usr/local/bin/multipartupload.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_blog/multipartupload.sh.erb'),
  }
   file { 'basemultipartupload.sh':
    path    => '/usr/local/bin/basemultipartupload.sh',
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode => '0775',
    content => template('mydevops_blog/basemultipartupload.sh.erb'),
  }

}
