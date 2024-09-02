class mydevops_postgresql_bdr::mydevops {

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

  ssh_authorized_key { 'barman@mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDKV5YU3mzOOD2fGyIgOFfYR0QoHNssXDXrTCs1nvAgTnTi0W6YC3BLbEZt6MyZieJ9no/LQCDVIl495PIDte32vKpSfuyEDXDz+cdrsOMkNsytAqxFnaHe9dbEAayBeyrZmBYjko1twjLe1v6VbwSNkKhByMrJKUFYFTv3/k1cMTxAtpa1pmfu/veNFoK2us6Xejwt5oQKDMU1gyUYYWMxXOJBB/Kv8NdSh9T3S3Gsy8+qnAdev5gKuq+nR7jyiWGQeyt8lN/0LWKJlCIeK+d8LfBuQcfKOU6DLHP5r47ockayza9eq7i/ALAEwavTOAYWZuNiqJtP1ItR9rMmMyhHCNUoRpOmBl61+NExPB00bOJYTfOWO1K1Gat0TUF4cx6tOHk1OMslXaZAytXoOSHQFxUXrh8k3ENgp8XL******',
  }
  ssh_authorized_key { 'postgres@mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQCkshCiHJKjYr126Q50J/TESV7AEGFGmsXtzKGGMd1kwPv/8sJTVPLq+36My55yAyXTu4MPjPJFEWYDBSUYZweC4mhOkwLta3OPFw/uPZ7spGN2LqtELFjsvFweRrcURZ0RZdwtkjVO2slY4MBFJjzQjMZaXwzQqLj0ply65CT7HtXBGjRV+rXB0LRo1Uaw2jrmuG5+gZc0iH/CzPCQuOcNbRP/1/o9b9L8Ba5Wrud3IkM2Cqo9GoHOtddLCQXuf0XNBnXSP88ZzIsqbHasApQLpBMwQdQic0F4EK/CFV8SGbMBsk2NH+hDGlXIJehOIBssa+CjTb5n6/aR7QSO3fk6bJSjVJh41D+xr7zH6Y90xRRYSvj7h1Za6a4pSkp9azjYmMfP7WfK3ZxEI0jGzi0O3gno/zonrIuNWsk/zuP63fND9xi8fSRp3yoh4i3JKCwxBk4brnXYGvmpp4QkTAoWZaKqFsKbJc2NEiCL******',
  }
  ssh_authorized_key { 'barman@mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDnPrCBnozaORoLpN4jAPRfAxjWbR2cfio1PAkAEM4ex5iBKQ4DcvYH8ifdccGorypE6vzb6yQo/i+vw1WSIoQUPZ8yCkubzpQrBMxrmBEEzR5sDpdvL69lsnULe/4YYge1Imzz6Wci3bZx4G1dLSvd6DXHNulIqTA8oPzdqc5HJmO4leGtr4HJPkGl6aOwOnRRxNVCYhb/N8byjZr2+0DTpJcSTkR7x1HxBnS9Mg97Z2u+4/QILppogctmGZvwa7FUIYhreX6nWuQhduZmt9q/iw5LHiLxFa/zV/ieGwXOEPqBE53/mWivLERBzU5zalOSEgIIj7LPbq/n2FnhmH3/6pmNVEhL/dRQoLlVuVTgaaB2GLwnkkC6Qc88hIPMJFYNeatIisYCxds67jEN+ulcABCn335IJj5QSbQ3mrfUgeA8LQb2eri6+4BHQbV2g9xnKQQkkrpIcvK/tLR+U08Fek/xb5Rof6E6Bgrh/VdK9J*******',
  }
  ssh_authorized_key { 'postgres@mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDeMM00W27IgQQVaDoCdLEIPgJa4zgNGXgBmqkpIDtzOWSbVXKkqvzwHH+Jhcng9Re/jB+df9z4IakwAfasGbmVzuqxMtThOZ4nteqpI26ruGyH+GrV6pk5txH4o8ojN1po+qQhLylbjeq5J1N4+/OkHjFT7Vx86Oo5yO4QdvYVy5qrliikRj/HZu0YriDIRyBjay47FrcaYgSNBbG4f/pwPafzHde+Qv03Hj//KtHAxcAQhhDVnKmBGi6UhBugUf50I7Zsf+etOjvWHVkmq26Zsgs/Kc+31fIx2VnDPDi13Zn81PHYLWrEEbclb/8Zq81/IV7S5cVqbwFKUys9gQwUig6jxgjDNh2WqEUqsaG9A5E1xNIKjUJjvKoAT5WVRISSeJ5s5+fYDTjl7FTzLhTjQe8ka9WN0t0+vZ1C13TkryfaR8cMtckw3Gbj4YK487dE6WaVBsYG0oeKD8fm7VPh1gF/HYYajEhK/********',
  }
}
