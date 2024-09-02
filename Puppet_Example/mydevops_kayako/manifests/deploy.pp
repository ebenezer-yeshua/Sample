define mydevops_kayako::deploy (
  $site,
  $ip,
  $servers,
  $staging=false,
  $deploy_keys=[],
  $self_signed_ok=false
){

 $root="/www/${site}"
 
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
  
  /*group {$name:
  	ensure => 'present',
  }
  user {$name:
 	ensure => 'present',
    home   => "/home/${name}",
    shell  => '/bin/bash',
    groups => $name
  }~>*/
  file{$root:
    ensure => directory,
    group  => $name,
    owner  => $name,
    mode   => '0750',
    require => User[$name],
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

  include beluga_firewall
  beluga_firewall::service{'rsync':
    ports => [873],
  }
  beluga_firewall::permit{'ssh from gitlab2':
    chain   => 'ssh',
    address => '10.0.1.202/32',
  }
  include beluga_fanotify_sync
  beluga_fanotify_sync::module{$name:
    path          => $root,
    user          => $name,
    password      => $rsync_password,
    exclude_watch => 'wp-content/wflogs',
  }

  package{'rsyncwrapper':
        ensure => hiera('rsyncwrapper_version', '1.0.2'),
  }
  file{'/etc/rsync-wrapper':
    ensure => directory,
  } ~>file{"/etc/rsync-wrapper/${name}.json":
    content => sorted_json({
        path => $root,
        subdirectories => true,
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
      'from="10.0.1.202"',
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
}
