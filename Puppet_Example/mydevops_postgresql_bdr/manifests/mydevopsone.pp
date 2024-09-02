class mydevops_postgresql_bdr::onemydevopscom {

  postgresql::server::config_entry{shared_buffers:
    value => '1GB'
  }
  postgresql::server::config_entry{maintenance_work_mem:
    value => '256MB'
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
    value => '10485kB'
  }
  postgresql::server::config_entry{tcp_keepalives_idle:
    value => '10'
  }
  postgresql::server::config_entry{tcp_keepalives_interval:
    value => '10'
  }
  postgresql::server::config_entry{effective_cache_size:
    value => '3GB'
  }
  postgresql::server::config_entry{checkpoint_completion_target:
    value => '0.9'
  }
  postgresql::server::config_entry{wal_buffers:
    value => '16MB'
  }
  postgresql::server::config_entry{default_statistics_target:
    value => '100'
  }

  ssh_authorized_key { 'barman@one1-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDM2GTzTl45FB6/gny2JE8aR7AMInV+imulck7LvsTrLeiGB5XZC+vM2WP3rjimJnqB/P1KlpM86rGvvVzbzF3uux5C3hA9tpZ3JnNBKY5q+4w07ZsL8O7PsiSSQSw9eQIZRiF3NJcI5RMWErHK1proD7uQKKYrmtZVmvB7Jws6Bd2+cmmwUEd5m7O9LpSRG/sDAchKoUWCyFx/WzRVva7/pVJTM5QUJg7JtjNzwzCs0vJp8wA7E08bOhE3wVdO3AMAN0lSUJMBvPhgp3FY4/Hw662MPOjEK4LofH03f+LItvRfE6PLqG6k1dSqZfG8SSQx42SgCT9800GALJB+RPQx',
  }
  ssh_authorized_key { 'postgres@one1-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC0BZ+wY4D1IwpHI+nbtN4SwojE9H3tXn2ZtNXe/Sn1mgvTbZdNclvzx2cS7wyvXEY4hJPswLAvGcoWe6sSCq7QMnS/SVX5w/+ailOgD1uYSfTAO9DOGbj/fbUVok18nA2cg/lMzx58Zj1OaEUh04Ry8bJIOG0PLdHnLT2wKhTCVXBjagem/6twvT0VaBlOhA6XMQo4y7NYq7zjA1PbsMaQ630TxUUT/vhkjq+Gp/JS3D+B5GiIiPtf6kwuyelbg3uADmygOs+jd4rof2MOfyMefQbhQ9jN2W55w61adZF3T3znmDgrKTesftoeHiVy0Tm8fbmnttXq7vs+oDS+Ekql',
  }
  ssh_authorized_key { 'barman@one2-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCvvcBvPZxafKu3hwsWGGLTlTRKHbiQ23o8foMIytm5XwuYaaPRnFRnXXS2eby71o78OMXSwhFkqdl4kofxw8HXehFZMkLUweQYT/uXWOH+OqMDLjFOmx2wLz7ZkdGDPtwoHHCrmrhOYBXpXLWCFopBSN8F41QcdbTvCqaKv28fd6PvUEdntJGkkeB5T7wYXreTDIXQHs8UvQ51R5dqhqboqwhsanN+jUjnckPttd3v8cbYOyLXkUDe8W7VwgVMih/ZBm36lKuoD28X9T1uMYaKDn1odl0yWkUId/TBNflcjD4Y6P9qvYD5UkR29OeywNbagOV86X9nqc93LpyE+gCn',
  }
  ssh_authorized_key { 'postgres@one2-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDgN+cAJBqWEXqiSde9QS0Ta3bfUoDXF57xJ4AAbEFiN594gT76tp2J3IAUMrCSF8ovcmI+1dJRv2d+lx4Fb9L5rUz6skKF7zIVCbWKSx95Co7Fg+SEcLiBs5duyRKzeAI8qgxGXKrjoASaF2LimAPsZ9RiyAFJjgiS8IY7BeQLDFO4CFphK1IBvQmbFaHxcFh4YxGDBqeaZYeN5Bu/C0h6eSlvxI6sMAG6ALyHReaJzCsWl0QeS864GIDiI79/wfD5uySwVvpFpt3CDUVyDrTNS7iCGeZbL5RVYDhqf13EriF3jk/qBP47zWl6FnsdAW3z66gZbNCJRmvYHAdeWNOF',
  }
}
