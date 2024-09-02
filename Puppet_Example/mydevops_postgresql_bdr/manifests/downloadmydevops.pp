class mydevops_postgresql_bdr::downloadmydevopscom {

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

  ssh_authorized_key { 'barman@download1-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDprdTY8r+rRy7KJixgdQ9dLGM1fTe+t1zU2IlHlhYh8ToXc/e9GNdJVpnNq4+nNYm6BNjCK+ZDvFQ7iAx+V/wPfdtu5Unya8BVfPsXwCY4hUWKX9YE9RdUnJoy/Jk+AnxUb4L9NLPNkJhQwPFcKODEZWir2vJinz/nuep3WSSTZekqeFcVY18wrssB4gy+QaHd3EUh/sHmpuubY71Vgz1HQRqqoWY3uLyyrKCIVvczqVq7uUWa9Q5qFeM8sRBQ6t9blZgDcZyJtH/sIpplwx4E4Yxe5rFq7eCCkjCJ9W/Xo0WGHydWcpzOdKrP6OHh1Uew+uugHo3P905C+Q9Bbl66pnZ3CdqHdbn9waboqiL3YepOo4QG81T/PdcPG5bY/1QnvzpXA7mt669rgnJKk6VUcbE7qaYVJObY/WvW0P2a/jF8TimD9F2Mb3baCowv3mHgX+zkYMitaHrVQMwpXmrygks+WTgfrNgubY/F8fCuWZwHsu/khphL4UJjLc+U6qE=',
  }
  ssh_authorized_key { 'postgres@download1-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQCYIrQZHxmCBKUFVwPyOgJna3QeXrvWuXCKiSz10Uc9ZfIjCFrqo+t+vxoG25k6yQGR+CTENf4wYKCPcnqTH16ugepN5ormGcbWAaWbffY8L0Zrx2N8iemUA18n9g/IB9Nd5J5u1Xjey07WL9AYnlGO+QpHf0CB+tzPypNCWiw+rfs5dkt6sqfshr4LOIR89OOsiLgEbWuvZlz5prl/XW+ieiZRAvix6OPSxzdcySfzFB9AZdwM+l+iuBqAulVXUcrqIrqj2U/58ytIiFWbFnh9iAZGQabPYDnwwfCmikj9AltBg7vIBE4wn/9wytwHSJSDzcg52edKcLRLya0tzIKQZLPW5Jrv0Paxodn6x/Ppb1jHfF3oUZ56UMANhVq3H/Q7Cm5/9u0lxRLpzrOTT9rNLWJlDYKd9x3GrEI+fzNntnGbmiqF+IzGZcwUPWPqsY3zojzXv4X3HfzKSdjtJ6NvKdmOLVjYYxRYY/nna8rAYE+YULzuxI/tvgLBAlVvT/U=',
  }
  ssh_authorized_key { 'barman@download2-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'postgres',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQCuElfKJXHEPbmrQKcDozfN0uyyX0LIqCEJ1fWAozjXFAiXcH4UeoAvIW/oEk0//DvnzZfgy2yxhn7g3vx2rydwELL910ulMO9kZhwk1HM0C3e6fxb9mwn6JkV7TNLs1Tn+v93CTcSgoxpmP3nLpN/NfL4QQ4GOHJ9d73C22vzl4KPQTcBUwFej6fzjvD6miWtzfzBLSNu0rpF43lm5xktz2/3Fnx+PXcoynPL7rrb0LUEUETmDlHUk8FTjpZcI3MNs/F/ZwolTddyIodfpbGZ5qomeoydUD+xH7JyQMXjtH1Y7TVElqi8wlbgnDXUpDfh4TWIqaATpVgWj3c565uvNTHPi14wj04uPQdIUG2pp4Kq7Lr+ElhQRzrb5RkTWGu10Q1n/i1wzy5CvqnhkHk/+j9O+lrCHeTtCAURN3073CGoBVe6h2gY6bQwp0ygKR62dd+HuITvaMqdR4Hom4cG/NXDAEsBJ1ezmJt2Oy1WMZ/m+pV+HUWxLmUXgfhCxwqU=',
  }
  ssh_authorized_key { 'postgres@download2-mydevops-virt-ewr1':
    ensure =>  present,
    user   => 'barman',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDsUiC+E07wsIV18wIqKrn850KKxe1KsSHfiQTebcFFN4ZZHQ4h+x0E+Fjxvr1JJoaKOXfJhZg8z2Q2s9eIPSJPHZeGtvgC5XljeUJEqxTTmh0L0xwTGNkp5v9hKk5R1goqf5JNq/rttrmvXXSmqqXsdgXpcsuMG1IOUbDKEOgPAbtlbwfZpzWN0SL3j0s3ROlltGnw77aCxBzlLE1QqkAvSIB3f61VuGxyU+7EeN5s4f7IIsEwKIwVG6Q4cJpksiN4zC8RTGsXbb41TgwJI5TT+2f2GOJOWOCrY2Akuxd/cWG/SsuwMqxqroAZA4J/RmNTVH9NHpalCBl5vKhU6Tkd+RNGvEY5fEi4cLrRcbdq4NTkcJnSI+DRc+/ImWWOyCuBiMvAOUBesi0v+VdjmRzS+AXtEWlSgnUdTxb6lnZr/OyYKaoGUD0MabRSildYjGdg8vKYNMl9r8rMGY4fEk3nrMEZzFPmJc+RIdmVqqSb9fkeWSMv4A7InCeY0wafU68=',
  }

}

