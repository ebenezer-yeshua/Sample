class beluga_docker::basic {
  package{'docker-ce':
    ensure => installed,
  }
  include firewall
  
  exec{"install-yq":
    command => 'wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && chmod +x /usr/local/bin/yq',
    path => ['/bin', '/usr/bin'],
    creates => '/usr/local/bin/yq',
    unless => 'ls -1 /usr/local/bin/yq 2>/dev/null'
  }

  firewall {'100 snat for docker':
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    proto    => 'all',
    outiface => '! docker0',
    source   => '172.17.0.0/12',
    table    => 'nat',
  }
  file{'/etc/docker/daemon.json':
    content => sorted_json({
      iptables => false
    })
  }
}

