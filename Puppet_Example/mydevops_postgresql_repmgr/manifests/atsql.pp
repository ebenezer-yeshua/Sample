class mydevops_postgresql_repmgr::atsql {

  postgresql::server::config_entry{max_connections:
    value => '500'
  }
  postgresql::server::config_entry{shared_buffers:
    value => '5GB'
  }
  postgresql::server::config_entry{maintenance_work_mem:
    value => '1280MB'
  }
  postgresql::server::config_entry{random_page_cost:
    value => '4'
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
    value => '2621kB'
  }
  postgresql::server::config_entry{tcp_keepalives_idle:
    value => '25'
  }
  postgresql::server::config_entry{tcp_keepalives_interval:
    value => '25'
  }
  postgresql::server::config_entry{effective_cache_size:
    value => '15GB'
  }
  postgresql::server::config_entry{checkpoint_completion_target:
    value => '0.7'
  }
  postgresql::server::config_entry{wal_buffers:
    value => '16MB'
  }
  postgresql::server::config_entry{effective_io_concurrency:
    value => '2'
  }
  postgresql::server::config_entry{default_statistics_target:
    value => '100'
  }
  postgresql::server::config_entry{min_wal_size:
    value => '2GB'
  }
  postgresql::server::config_entry{max_wal_size:
    value => '4GB'
  }
    postgresql::server::config_entry{max_worker_processes:
    value => '32'
  }
  postgresql::server::config_entry{max_parallel_workers_per_gather:
    value => '4'
  }
  postgresql::server::config_entry{max_parallel_workers:
    value => '32'
  }
  postgresql::server::config_entry{max_parallel_maintenance_workers:
    value => '4'
  }
  
ssh_authorized_key { 'postgres@vtiger1-psql-db-virt-ewr1':
  ensure => present,
  user   => 'postgres',
  type   => 'ssh-rsa',
  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDA27nDIvQHKhKD7jKMaeSVcZqCXpHWYL/j/cgwyHCXVhp/U6pP0Zpw7Rw6EstCGYM0D+9TRf3GJ2bjRnRPNv7M8O5h3M9riXeTgadX8nk/A9ZKWmLtMett2+YRNcQPF73KpVFGzW9n4awBI44kZsFwFvzkzD6jK9QR4juM/QbLnYBULMRLyUJtN8PZSwSuCJ5kNnEv0e8n0M7PkUlaUxK9fFCjnyCxb+bRTAXZstGdrJUJuayWOhqTv12UAQ3qJCUbDLFSRTyoW5wTWimDliPqN2zcJn80XlcPGnP+Fjlk+gVTmIFuOm4Kq8L83Q3nxIjVgMfmd/ehdMpSbhmDK6bSq84SqfclexEB4nvzPsE4f6aU+t3EX0WHBhjzEKmTJLDlevSd2WwNteePEU6yaWpVO6e8baot9fD6BRgY4t1dMiuQ0rgykWaed36CqRBvTDYIhJqf20oDdefjdlD9dAXIzYvTS95pitXbffcJoj14Ui52JUnA682hXwngb7c8Rp8=',
}

ssh_authorized_key { 'postgres@mydevops2-psql-db-virt-ewr1':
  ensure => present,
  user   => 'postgres',
  type   => 'ssh-rsa',
  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDH9/BJnVwCc4kTZAWoOZ1zGsyF8MWtGfoNWu6M7L65t55A1nWS94ODXmd4m6WGMdYZzNEaCNHcbjh7ybsosTSReV7XiCRZ39aciTZGR4wG/BSAolUFQ1gGTczV42ZGQYmcpy4YE1aCGs9klvyW8pFzrYLQ3L0Ve7NleVatAuUIIGGErgTgwUjymyNofSbrfaNU4TSMHv0AJgyFcZiVL54ooxnfbPleqRuw4M+CbF2PC2RG92S4WZdPPbmVWRy+QELeJZ3tqJPuQT8JGIri6ETMEri98b6biZqvQawsY/ONxTLVyK8Yqg0oeIf3R/vrybZyy9tcuLWjDaz4bIQu3Vy80+e6/ZtxYk+ctqI/OnHXUXW3Et6qVT8+2fBKMBHPWS7J1bq8gZhKeA/J5AZzoVMyho6CqCNkoJ3+cnumQ7jIpW206nt5ePYxxLwUy9CRlJZWQhjj8e6TQhpclIPvxf+19J0ZKUh79fMrh26uFjEXa7fzEStAUiLuMqszNvZ/6Hs=',
}

postgresql::server::role{"postgres":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("postgres", "*****")
} 

postgresql::server::role{"web_user":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("web_user", "******")
} 

postgresql::server::role{"c1webdata":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("c1webdata", "******")
} 

postgresql::server::role{"nagesh":
    createdb => false,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("mydevops", "******")
} 

  postgresql::server::role{"webscript":
    createdb => false,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("webscript", "********")
  } 

  postgresql::server::role{"one_mydevops":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("one_mydevops", "******")
  }

  postgresql::server::role{"ccav_vote":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("mydevopsvote", "*******")
  }

  postgresql::server::role{"automation_feedback":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("automation_feedback", "*****")
  }

  postgresql::server::role{"remoteaccess_faq":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("remoteaccess_faq", "*****")
  }

  postgresql::server::role{"mydevops":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("mydevops", "******")
  }

  postgresql::server::role{"mydevops_faq":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("mydevops_faq", "******")
  }

  postgresql::server::role{"customersfeedback":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("customersfeedback", "******")
  }

mydevops_postgresql_repmgr::database{"saleshub":
   user => 'saleshub',
   password => '0ToiasctkckzeW8vrxb'
}

mydevops_postgresql_repmgr::permit{"Access to web_user user for saleshub db":
    dbuser     => 'web_user',
    dbname    => 'mydevops',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '10.0.1.9/32',
        description => 'Access to web_user user for saleshub db from AWS1'
      },
      {
        address     => '10.0.1.202/32',
        description => 'Access to web_user user for saleshub db from AWS2'
      },
      {
        address     => '10.0.1.126/32',
        description => 'Access to web_user user for saleshub db from salesreport1'
      },
      {
        address     => '10.0.1.130/32',
        description => 'Access to replication user for saleshub db from salesreport2'
      },
      {
        address     => '10.0.1.46/32',
        description => 'Access to web_user user for saleshub db from platform-us-mydevops1'
      },
      {
        address     => '10.0.1.50/32',
        description => 'Access to replication user for saleshub db from platform-us-mydevops2'
      },
      {
        address     => '10.0.1.147/32',
        description => 'Access to user for saleshub db from vtsql1'
      },
      {
        address     => '10.0.1.38/32',
        description => 'Access to web_user user for saleshub db from platform-mydevops1-virt-ewr1'
      },
      {
        address     => '10.0.1.42/32',
        description => 'Access to web_user user for saleshub db from platform-mydevops2-virt-ewr1'
      },
          {
        address     => '10.0.1.177/32',
        description => 'Access to web_user user for saleshub db from 10.0.1.177'
      },



    ]
  }

  include mydevops_firewall
  mydevops_firewall::service{'POSTGRES':
    ports      => [5432],
    log_reject => true
  }

  mydevops_firewall::permit{'postgresql permit AWS1':
   chain   => "POSTGRES",
   address => '10.0.1.9'
  }
  mydevops_firewall::permit{'postgresql permit AWS2':
   chain   => "POSTGRES",
   address => '10.0.1.202'
  }
  mydevops_firewall::permit{'postgresql permit mydevops':
   chain   => "POSTGRES",
   address => '10.0.1.34'
  }
  mydevops_firewall::permit{'saleshub permit salesreport1':
   chain   => "POSTGRES",
   address => '10.0.1.126'
  }
  mydevops_firewall::permit{'saleshub permit salesreport2':
   chain   => "POSTGRES",
   address => '10.0.1.130'
  }
  mydevops_firewall::permit{'saleshub permit mydevops1-virt-ewr1.mydevopscdn.com':
   chain   => "POSTGRES",
   address => '10.0.1.102'
  }
  }
