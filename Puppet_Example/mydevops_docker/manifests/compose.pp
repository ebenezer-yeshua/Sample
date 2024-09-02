define beluga_docker::compose(
  $template,
  $deploy_key=false,
  $project=not_set,
  $env_file=not_set
  ) {
  include beluga_docker::install_compose
  file{"/etc/compose/${name}.yaml":
    ensure  => present,
    content => template("beluga_docker/compose/${template}.yaml"),
    notify  => Exec["docker-compose-up-${name}"]
  }

  if $env_file !~ /not_set/ {
    $set_env = "--env-file ${env_file}"
  } else {
    $set_env = ''
  }

  if $project !~ /not_set/ {
    $set_project = "-p ${project}"
  } else {
    $set_project = ''
  }
  $compose_params = "${set_env} ${set_project}"
  
  exec{"docker-compose-up-${name}":
    refreshonly => true,
    command     => "/usr/bin/docker compose -f /etc/compose/${name}.yaml ${compose_params} up --detach"
  }

  file{"/usr/bin/compose-${name}":
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template("${module_name}/compose.erb"),
  }

  file{"/usr/bin/compose-update-${name}":
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template("${module_name}/compose-update.erb"),
  }

  if $deploy_key {
    include beluga_docker::compose_deploy
    ssh_authorized_key{"deploy-${name}":
      ensure  => present,
      user    => 'deploy',
      type    => 'ssh-rsa',
      key     => $deploy_key,
      options => [
        "command=\"/usr/bin/sudo /usr/bin/compose-update-${name}\"",
        'from="162.255.24.202"',
        'no-agent-forwarding',
        'no-port-forwarding',
        'no-pty',
        'no-user-rc',
      ],
    }

    include sudo
    sudo::conf{"deploy-${name}":
      priority => 10,
      content  => "deploy ALL= (root) NOPASSWD: /usr/bin/compose-update-${name}",
    }
  }
}
