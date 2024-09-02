define mydevops_blog::deploy (
  $site,
  $ip,
  $servers,
  $staging=false,
  $deploy_keys=[],
  $self_signed_ok=false
){

 $root="/home/sites/${site}"
 
 concat{'/etc/rsyncd.secrets':
    mode           => '0600',
    owner          => 'root',
    ensure_newline => true
  }
  concat::fragment{"${name}-rsync-password":
    target  => '/etc/rsyncd.secrets',
    content => "${name}:${rsync_password}",
  }
  include rsync
  class{'rsync::server':
    use_xinetd => false,
  }
  
  file{$root:
    ensure => directory,
  }
  rsync::server::module{$name:
    path           => $root,
    require        => [File[$root], File['/etc/rsyncd.secrets']],
    read_only      => 'no',
    outgoing_chmod => false,
    incoming_chmod => false,
    secrets_file   => '/etc/rsyncd.secrets',
    auth_users     => [$name],
    hosts_allow    => $servers.map |$server| {$server['address']},
    uid            => 'root',
    gid            => 'root',
  }

  include mydevops_firewall
  mydevops_firewall::service{'rsync':
    ports => [873],
  }
  mydevops_firewall::permit{'ssh from gitlab2':
    chain   => 'ssh',
    address => '10.0.0.1/32',
  }
  include mydevops_fanotify_sync

  package{'rsyncwrapper':
    ensure => hiera('rsyncwrapper_version', '1.0.3'),
  }
  file{'/etc/rsync-wrapper':
    ensure => directory,
  } ~>file{"/etc/rsync-wrapper/${name}.json":
    content => sorted_json({
        path            => $root,
        subdirectories  => true,
        'post-commands' => [
          {
            command => "/home/sites/restart.sh",
            name    => "restart"
          }
        ]
    })
  }

  file{"/home/${name}/.ssh":
    ensure => directory,
  }
  $deploy_keys_x = $deploy_keys.reduce({}) |$cumulate, $deploy_key| {
    $key = "${name}-${deploy_key['name']}"
    $valuex = $deploy_key.filter |$entry| { $entry[0] != 'name' }
    $value = merge($valuex, {
      ensure  => 'present',
      user    => $name,
      options => [
      'command="/usr/bin/rsyncwrapper"',
      'from="10.0.0.1"',
      'no-agent-forwarding',
      'no-port-forwarding',
      'no-pty',
      'no-user-rc',
      ],
      require => File["/home/${name}/.ssh"],
    })
    $tmp = merge($cumulate, {$key => $value })
    $tmp
  }
  create_resources(ssh_authorized_key, $deploy_keys_x)

  $non_local_servers = $servers.filter |$server| {$server['name'] != $::fqdn}

  file{"/root/${name}-gitlab-ci.yml":
     content => template("${module_name}/gitlab-ci.yml.erb")
  }
  file{"/home/sites/restart.sh":
     content => template("${module_name}/restart.sh.erb"),
     mode    => '0755',
  }
}
