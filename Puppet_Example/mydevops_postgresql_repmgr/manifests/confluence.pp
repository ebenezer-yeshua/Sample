class mydevops_postgresql_repmgr::confluence {

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

mydevops_firewall::permit{'ssh permit confluence-db1-virt-ewr1.mydevopscdn.com':
  chain   => ssh,
  address => '10.0.1.226'
}
mydevops_firewall::permit{'ssh permit confluence-db2-virt-ewr1.mydevopscdn.com':
  chain   => ssh,
  address => '10.0.1.230'
}
mydevops_firewall::permit{'ssh permit db-blog-stage':
  chain   => ssh,
  address => '10.0.1.166'
}
ssh_authorized_key { 'postgres@confluence-db1-virt-ewr1':
  ensure => present,
  user   => 'postgres',
  type   => 'ssh-rsa',
  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCxN55rHble+AAZ+Zw7TC6jo5SyL9BvFCAwZL5ExDOojFE/qD8/ORQc0AYmD6WFqHyrKn+mC4be+nSPbOOYqMiYOqONgSTRmzCc1vbHzBXHSF2bYhYPycy/2z8rZVoKd7SJd1ux36m3+91wdmNxVvBsUXajnHEFQ7PUesYEAivDL3DRUDZ7dXOBkZOywgw0jRhZ9AKSs96PfnpdmpCzNxwl16gaGTqLqVop9qjuLM/pV4+xcJj+g4fRlMpBvG65733rt/RjIrTa6xsyukH+teoR83rW6G9HrITaZ9BQ62JSisLZu2*****',
}

ssh_authorized_key { 'postgres@confluence-db2-virt-ewr1':
  ensure => present,
  user   => 'postgres',
  type   => 'ssh-rsa',
  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCkuOveSXK7IJrTTHS+r4WmFf3FesghUpnaxmI+Zo5ERQe7VDu+Yi7R55tGTWyh7SKOLK74nG3zVif78vOnRhDGm8r4eloVJuPL3DbVWn29U6wdSgerAz5B9Jb2Olw4ku5VLysd7vzKhzzhIxbnYvQjxGsS47qacJvIg5TgszAIkMUYens3XfIjv31/XlYEvjcCrdeIYWiFV6rM5HhPF3N9IF5p9cQu4Ivaa/Co+7OUn3bcec4joZQbokjtJ0l3T1zhBIJDtt2vML4t9qkj3J/u0BNKaV8Z4xOtXug8hg9x4QFgSBYCWi8z******',
}

postgresql::server::role{"confluence":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("confluence", "****")
  }

postgresql::server::role{"jira":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("jira", "******")
  } 

mydevops_postgresql_repmgr::database{"confluence":
   user => 'confluence',
   password => '*****'
}

mydevops_postgresql_repmgr::database{"jira":
   user => 'jira',
   password => '*******'
}

mydevops_postgresql_repmgr::permit{"Access to confluence user for confluence db":
    dbuser     => 'confluence',
    dbname    => 'confluence',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '10.0.1.250/32',
        description => 'Access to confluence user for confluence db from confluence1'
      },
      {
        address     => '10.0.1.190/32',
        description => 'Access to confluence user for confluence db from confluence2'
      }      
    ]
  }

mydevops_postgresql_repmgr::permit{"Access to jira user for confluence db":
    dbuser     => 'jira',
    dbname    => 'confluence',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '10.0.1.250/32',
        description => 'Access to jira user for confluence db from confluence1'
      },
      {
        address     => '10.0.1.190/32',
        description => 'Access to jira user for confluence db from confluence2'
      }      
    ]
  }

mydevops_postgresql_repmgr::permit{"Access to jira user for jira db":
    dbuser     => 'jira',
    dbname    => 'jira',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '10.0.1.250/32',
        description => 'Access to jira user for jira db from confluence1'
      },
      {
        address     => '10.0.1.190/32',
        description => 'Access to jira user for jira db from confluence2'
      }      
    ]
  }

mydevops_postgresql_repmgr::permit{"replication":
    dbuser   => 'repmgr',
    dbname   => 'replication',
    dbauth   => 'trust',
     allow   => [
      {
        address     => '10.0.1.226/32',
        description => 'confluence-db1-virt-ewr1.mydevopscdn.com'
      },
      {
        address     => '10.0.1.230/32',
        description => 'confluence-db2-virt-ewr1.mydevopscdn.com'
      },
      {
        address     => '127.0.0.1/32',
        description => 'Replication allow localhost'
      }
    ]
  }
  
mydevops_postgresql_repmgr::permit{"repmgr":
    dbuser     => 'repmgr',
    dbname    => 'repmgr',
    dbauth   => 'trust',
    local    => true,
     allow   => [
      {
        address     => '10.0.1.226/32',
        description => 'confluence-db1-virt-ewr1.mydevopscdn.com'
      },
      {
        address     => '10.0.1.230/32',
        description => 'confluence-db2-virt-ewr1.mydevopscdn.com'
      }
    ]
  }

 } 
