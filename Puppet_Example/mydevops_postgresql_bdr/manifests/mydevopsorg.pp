class mydevops_postgresql_bdr::mydevopsorg {

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

  ssh_authorized_key { 'barman@mydevops-org-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCyrsYMolNMF6d8dAlji/tmS7Azaw0+ruaaDaKxslr7ZqLbm54DKk/Vh6jifQl3ytjQfA48EFqUrZeKoo/CKTkQvxlR87KjEnoT5tmbjx5Kk+bfnnWaCPV2bJlWnIxvmsHXbnHp+/YBumQkiyjUe2ErKSS13P2CqBnjmcpOr42OGgwXvavUM5L+Vxvwb6xnDlQhij7mUHT59zM0dsNx1H8loe3C6uQLK68Je9+7veRBnbvrvCZ2AxIMeq+ikn/lvTxFDFfO5WHtHWIqiMEp9FogbSTHGE+FwMvCjKdHWFlprECY7iajBpumGL12kDbwSG9AjjtBdL9bOvG9xUEm98bh',
  }
  ssh_authorized_key { 'postgres@mydevops-org-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC+dsjYvd0/29IXyMATs2nWUS1v8o/RKmrXzQM3/CoCTQRVtPEauVQgJkiJKN55+2BKxuiFXPJ8W1D/eigVqZhTQJCXvAm4AgVaa9FOExmWtq/X/nhh+O25UtC1cb/Z694ECAz3rpsbsifxdkcwdnC5gpj5yFfjCiFbeIuZmGaabPl2kW98ZgF+qP43ggGFyRHJczpcIhtlUTxGql3GcpnXq7mWZvfBPsCbNxXfdGU1DVkqF43eTW63tVtlUx7rUKxP+zROSsMAP23pxBvkBGeL0mMn6kvXzLGqSLB8fA41FOTUSjVUL3LJHytwe1SAd4tpTYeWh/PWgkDSG0r2xY4p',
  }
  ssh_authorized_key { 'barman@mydevops-org-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC481lXcxU9nB+8QJguWtZi+JZc3dYh6ryIGMv5mtUMG2cff6/aZp+SXYbCVsP8n9SoBxyH+IKx9uBb5vs2xIgoLHWqmkJ8Jktv8BIL7AfNLi5VD9zmBt5IHKjSdZTgF+mCXP4s5D/sF/0b4xah5ExNA3ppM8bCy/gFWXVUrJXsrrFrKxpqk9Ucy9vEqt5rFiLULSBX/Y9/Uca9It1OM3lFfBPuE/2Icit/uyHo5530JJSWKNKOq6ToHe25Hnapcdt31U/ys09qXvVUtd/HinIk9TB6j7dEnqtFYZ34C6yL+BHlZwwn+0t/Kol/LZJahBqwdvZJEMCWqd/RwOoogA3x',
  }
  ssh_authorized_key { 'postgres@mydevops-org-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDUhm2dIdyYjFBiHl0Zms9nyDmlTmw76VzuCciR8PQhc+5Yaqgw1jEUd5haHFPaxEbbyGulw4DI8MEEf0tDAALnbHARWpxl394OQholneqYBivS3dDgbC6FxADFIHxq7IiYBwSwgXNZhRK/dYhpLKA/wsBcrGPoiCrCckSrbA7Qvu1u3XgmSNnxExb4YCVkms10xcZs96y28yOEw/KEwRIKmohdD0AL/SU+zhJF5D4lX1YHwHeZG/uABMdeA8ioXXVroC5CM+1NT2r0QsTxhHpHz19VLEYGnsCRa56EMf04bozZ0CyWgw1SdhkF2ayuPIclmTBDAg7xaBGn7flPBj4n',
  }
}

