class mydevops_postgresql_bdr::mydevopscoin {

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

  ssh_authorized_key { 'barman@mydevops1-co-in-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC2Sd55X6IjvhkdlKzOhvXv8ytUZBv/oxqwUN3JiuRR4BwzualJxlbbtByZP6iIC0v/Y7Wam00fm/OvmCPuAeTW9pg212tbEhrJslE3QF5XFF5w1JvoN3gs0pWVAw8QhnbjcZFLfmAh73rNqmFtlzUs66FfDTKJFBjGfNwy9vOq6BmijoSnbDpwHTv9jnxlb1r0uY6rEt2nDZqYKRpHoP105iKBVUByccDQs6ne83kEJETAtwY4vx+CESP3svbBq38ktsdoHr2ni5EwmUqhtJNT+DEbJnDNLsIMfyUbm0vN/uHTg1RGw+L/CeMulJY47lNzY8s+cS5dn728V9wCZTK5',
  }
  ssh_authorized_key { 'postgres@mydevops1-co-in-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDFtj1Z0AuV7gkzR0iLhNhLwGLptBtshF6Cgswv66FyyTPpmMtxDGgo/XVjgqeq6JXstj+nGXE0dltPDr9d35bA7OvGCwYE1aKWOC6LyBxcuKL4qqPt5WsNWYztceuop39iqnvcXl02oBvmuoac8iZMZ37jSyVOq4vtLwypwmPPclUfg4dp4NwYcCzH21qjJufetJCySYK/6DSnCUlBBV1i3829AVYmOK/lt/qCWozE3bKHwvOFcGo7Gt6nOr5LcBFUOK3Qett5oCh1aDcC/a5Y8yYvm6pGiLEFH2kHtUpi0gU1PYmlfrBcbxdPfy41pVtAjFijrcKxsPKLVbWL2T4f',
  }
  ssh_authorized_key { 'barman@mydevops2-co-in-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDANO26Q/6alUPMXUaBY8abEdGLfbEtHcINLOEVrozCR1K1X/3deEQKjKVz06oYD4J9E8fWRqU6unvMKtWYEGH+8FvBsMO8dPbIkbyNflV3DRpv56BS/XVreIthG1YhJsaYEb9nfIrw3opnFeq+Bg1kuDQ8yXGS3aPjTNLcYlSMVWh63HjAisnjie7Yio5RLJKrHSvSN/KulHmfcXZ7y4f868IJodACf0ii3/2DtUUHrGZf18NTFdSbuXLqcUuU2tA9kHr6JUDPMwa1eN1FLdwULPhHxB8/iDF6bRzbLAxBVjK0+GgnSDX1gnfyqJLg03D/rCHXID00ld1eWk+zl5TP',
  }
  ssh_authorized_key { 'postgres@mydevops2-co-in-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCrW/3yP2DKE+onqRpgJiW77GSphOZNqRscIXcvIfJjYOm7NU4AV1df/kPRT4D68/fc/abLN2ByUNg3ETEEimM5Mc2CM0fE4GYul6HUVFkQWEdfra3J2uzXBF4YSIwx4Q2fD7cE1rqxS0hxpgh4GKxtLM4M++FA3u4CkJNdV7C7nqv/UWyqPFi12PjXvVnwqylr0o20RFMXOThvc3sY26z5idE6R3rCuGx2O509aBsI3GoEAvCMp3vFWe8dPIRycl42Vn7FDCiCqXRn8nXyuhm5FA2D3IthUjXCg2tlXYU2rhV+MFVrk0uKn/e9H3yHA8vvXY9LsB1xQXqbS/P5vfQx',
  }

}
