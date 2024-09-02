class mydevops_docker::compose_deploy {
  beluga_firewall::permit{'compose deploy from gitlab2-virt-ewr1':
    chain   => 'ssh',
    address => '10.0.1.202/32'
  }
  user{'deploy':
    ensure         => present,
    home           => "/home/deploy",
    purge_ssh_keys => true,
  }
  file{'/home/deploy':
    ensure => 'directory',
    owner  => 'deploy',
  } ~>
  file{'/home/deploy/.ssh':
    ensure => 'directory',
    owner  => 'deploy',
  }
}
