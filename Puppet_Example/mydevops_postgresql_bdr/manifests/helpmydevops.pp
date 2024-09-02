class mydevops_postgresql_bdr::helpmydevopscom {

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

  ssh_authorized_key { 'barman@help1-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC63sMsfFiu+VWfBpQKhnpehcuaVQhvoIiSnESlQ1lHi7X2XyMccxKR919itfm3M9bV142d97nyvWAOiz7w9ax0VcOne2i85sxdrSGMqxPGNPQuAc8E3GSmRhtPIOYlFohEKnb03a+hMk5p+TGwI0DJ/cb1hYe/8sGR4dZXKtUoJGqYBssOUd2xDaMq1T1KlLujduzlyLtCMtzylQO5oVALBcyQCX6TXjf4wCcoSjkGD23+/iYI2i0N5PuRJKFgpQilcB8/AlJAT43qHWe8NMKnkseTP6KhG+xnbQEqgtHK5o/N1GWdE0kDRTqvUXJBBgmV6D1/DTB50JKuWCATPIl3',
  }
  ssh_authorized_key { 'postgres@help1-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC3dNN33/30KiCUsDS8q+qmCwzsmQnAdjX1WGM/O6wythqyNZYxXyvYLLo1oVtwTZ8ln7Jul/kDHC9taHY192616IBi9PEoWmmR6skVSB2AFZ1jhPD0hXv3VoheGe24h1id1LDSUTspyQVAwOugi8tesuRBMSDnxtyPSan79osIac5TJZrxoNZViILfKRX6F2IYDhcT0g98vtpZNcu6EmtzwsL2fM3Dm/DqdaqsH4MdIdJj4xyqvVkyUnhiL6DjfkDDKoGnjMNn7sOPu6OSd2X7/VoodGtbFoZRXRJBZItI7+P+psdqMMX4L2gUJ6tNiNPEFgjH+3T4SspYYFfhkPRH',
  }
  ssh_authorized_key { 'barman@help2-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCzAztgh0zc9VRLnWsaDd+2gFSGk3PAbxp0RruqIGsM3is5/4lXSDZAHdZ47wxC8BhPHdix8WHIUR6Rsemq49yxugOusybLeARaV3j0z2GPKvckDqzs/LaZJOr3RnC1lThK2fq9+hKUfW0s1bgATnZP3GWlwCXvks/MmcrnSCKffggsThvLhfzwYeDLCxhq/qkg9fc/fD3atUIU/ny+Ot6YZsAfQq3r7zsUxWoRFSjb1jvCRb3fkRv64kNJSCosL75evcrZqkWgrcO5jEZADpyOmOvv+RmysYslfTsad6r/3p/WrBph2MQUam6g28YP8bZ6Qd57uZYUTO8AvLmI5mBv',
  }
  ssh_authorized_key { 'postgres@help2-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC7/8UsBA9KLSeNwGGl/1RQXriq8rYbOyyX1u7ko86jsp/KjkrTlKZ/r+2zrcGXjv18Sn3uHGY7Hlll3jrBC1HW7Flsa6zWncl+z+A594QB71EWF0Dptck0oAYEi0wt5UNiui04LCOgGWbCYS124Is53KebaJ6T75r1RXz+DYFBFWnsnk56rpvJMWWgFSizNxdFTVDCOXk+zbipYUQ2XudzzzS92h14OwZqRtWox6yfF/dCnXoW5wl+XQE5llSssMZZUNPQB3kmmQ9UBnqVnt7VJjTU3qufoDuYVyjWioehDp3/+tVYhlQ4XIzkck/fkx6ur7XpUPOpQ51AjAqIQaEH',
  }
}
