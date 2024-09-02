class mydevops_postgresql_repmgr::jira {

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
  
ssh_authorized_key { 'postgres@jira-db1-virt-ewr1':
  ensure => present,
  user   => 'postgres',
  type   => 'ssh-rsa',
  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDW+2q9QRZQBViHaJzYMOJFUi2DltDVIcRgrfmGYIiavM210GbLLZmHypRnGeufmEqXrfubBnfPBJEaqlRbaKyPt8oU6HjBoXdogvCcgyxnYHQDDKaYG2QZb+xP4epqB8SdPATKLR4/XJdO/2FTj+HOQH9BV/gJY1SEucidaTfrPhBMQxOGuebO1lefU0xFbZHBcjXDxfvTroQ48llIdMcXxAZffS8nbg9szrxDroosGM1QwgIleovqsoluidYeu5ozgyfD4KfACsCQ2VGjq5OU5feEPFx+Dbyi2E1VjIWdvtSB/3dRF7s9zer1QNt9Ei8FsyW6viZ0TIJkl+iUXmDkBh4fDRFs3+Lb8xjfl/9y35qcdBWVXN5wJjuiGIcbK6ccFUViGw29vao1jyvzDNDO9dYQVN4aWvP+tfIugAKhJ3g+u1+hclTCIcKaDg1a74nNu18Ctn1g4icRLw/O9MJJIBEW3AoJFhN+MtoY2+T+gf30JXBFLEZlh+tY4gIYx88',
}

ssh_authorized_key { 'postgres@jira-db2-virt-ewr1':
  ensure => present,
  user   => 'postgres',
  type   => 'ssh-rsa',
  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDW+2q9QRZQBViHaJzYMOJFUi2DltDVIcRgrfmGYIiavM210GbLLZmHypRnGeufmEqXrfubBnfPBJEaqlRbaKyPt8oU6HjBoXdogvCcgyxnYHQDDKaYG2QZb+xP4epqB8SdPATKLR4/XJdO/2FTj+HOQH9BV/gJY1SEucidaTfrPhBMQxOGuebO1lefU0xFbZHBcjXDxfvTroQ48llIdMcXxAZffS8nbg9szrxDroosGM1QwgIleovqsoluidYeu5ozgyfD4KfACsCQ2VGjq5OU5feEPFx+Dbyi2E1VjIWdvtSB/3dRF7s9zer1QNt9Ei8FsyW6viZ0TIJkl+iUXmDkBh4fDRFs3+Lb8xjfl/9y35qcdBWVXN5wJjuiGIcbK6ccFUViGw29vao1jyvzDNDO9dYQVN4aWvP+tfIugAKhJ3g+u1+hclTCIcKaDg1a74nNu18Ctn1g4icRLw/O9MJJIBEW3AoJFhN+MtoY2+T+gf30JXBFLEZlh+tY4gIYx88',
}

postgresql::server::role{"jira":
    createdb => true,
    createrole => true,
    superuser => true,
    password_hash => postgresql_password("jira", "*****")
  } 

mydevops_postgresql_repmgr::database{"jira":
   user => 'jira',
   password => '******'
}

mydevops_postgresql_repmgr::permit{"Access to jira user for jira db":
    dbuser     => 'jira',
    dbname    => 'jira',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '10.0.1.26/32',
        description => 'Access to jira user for jira db from jira1'
      },
      {
        address     => '10.0.1.62/32',
        description => 'Access to jira user for jira db from jira2'
      }      
    ]
  }

mydevops_postgresql_repmgr::permit{"replication":
    dbuser   => 'repmgr',
    dbname   => 'replication',
    dbauth   => 'trust',
     allow   => [
      {
        address     => '10.0.1.54/32',
        description => 'jira-db1-virt-ewr1.mydevopscdn.com'
      },
      {
        address     => '10.0.1.58/32',
        description => 'jira-db2-virt-ewr1.mydevopscdn.com'
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
        address     => '10.0.1.54/32',
        description => 'jira-db1-virt-ewr1.mydevopscdn.com'
      },
      {
        address     => '10.0.1.58/32',
        description => 'jira-db2-virt-ewr1.mydevopscdn.com'
      }
    ]
  }
} 
