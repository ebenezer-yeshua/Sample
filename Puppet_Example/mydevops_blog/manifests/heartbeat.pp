class mydevops_blog::heartbeat (
	$authkey      = '14bcb02b20f78c2ef9d04ba2be5e21e1',
	$virtual      = '',
	$nodes        = '',
	$resources    = '',
	$udpport      = 694,
	$ucastIf      = 'eth0',
        $nodeips      = '',
        $ping         = '',
	$logfile      = '/var/log/ha-log',
	$autoFailback = 'off'
){
	package { "heartbeat" : ensure => installed	}

	service {
		"heartbeat":
			ensure    => running,
			enable    => true,
			hasstatus => true,
			require   => [
				Package["heartbeat"],
				File['/etc/ha.d/haresources'],
				File['/etc/ha.d/ha.cf'],
				File['/etc/ha.d/authkeys']
			];
	}

	file {
		"/etc/ha.d/haresources":
		         notify  => Service["heartbeat"],
			 mode    => "0644",
			 owner   => root,
			 group   => root,
			 content => template("mydevops_blog/ha.d/haresources.erb"),
			 require => Package["heartbeat"];
		"/etc/ha.d/ha.cf":
		         notify  => Service["heartbeat"],
			 mode    => "0644",
			 owner   => root,
			 group   => root,
			 content => template("mydevops_blog/ha.d/ha.cf.erb"),
			 require => Package["heartbeat"];
		"/etc/ha.d/authkeys":
			 mode    => "0600",
			 owner   => root,
			 group   => root,
			 content => template("mydevops_blog/ha.d/authkeys.erb"),
			 require => Package["heartbeat"];
	}
}