class beluga_docker::install_compose {
  package{'docker-compose-plugin':
    ensure => latest
  }

  file{"/etc/compose":
    ensure => directory
  }
}
