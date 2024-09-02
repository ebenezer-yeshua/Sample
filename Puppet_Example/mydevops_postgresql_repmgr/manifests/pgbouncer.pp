class mydevops_postgresql_repmgr::pgbouncer($pgbouncer=true, $pgbouncerport, $pgbouncermaxclient, $pgbouncerpoolsize, $pgserverconnecttimeout) {

if $pgbouncer {
  
      include mydevops_postgresql_repmgr::pgbouncer::repmgrpgbouncer
      mydevops_postgresql_repmgr::pgbouncer::repmgrpgbouncer::config{'pgbouncer config':
         pgbouncerport => $pgbouncerport, 
         pgbouncermaxclient => $pgbouncermaxclient,
         pgbouncerpoolsize => $pgbouncerpoolsize,
         pgserverconnecttimeout => $pgserverconnecttimeout
      }
    
  } else {
  
      notify {"pgbouncer does't configure":}
  }   
}

class mydevops_postgresql_repmgr::pgbouncer::repmgrpgbouncer{

package { "pgbouncer": ensure => installed, }
service { "pgbouncer": ensure  => "running", enable  => "true", require => Package["pgbouncer"], }
 file { "/etc/default/pgbouncer":
    ensure => "present",
    require => Package["pgbouncer"],
    notify  => Service["pgbouncer"],
 }
 sudo::conf { 'pgbouncer':
    ensure  => present,
    content => 'postgres ALL=(ALL) NOPASSWD: /etc/init.d/pgbouncer',
 }
 $pgbouncerdb = []
 file { "/etc/pgbouncer":
   ensure => present,
   owner  => 'postgres',
   group  => 'postgres',
  }
 /* telegraf::input{'pgbouncer':
    plugin_type => 'pgbouncer',
    options     => [{
      address     => 'user=pgbouncer password=uSainooSudoomahl7IN dbname=pgbouncer'
    }]
  } */
 define config($pgbouncerport, $pgbouncermaxclient, $pgbouncerpoolsize, $pgserverconnecttimeout){
  file { "/etc/pgbouncer/pgbouncer.ini":
    ensure => present,
    require => Package["pgbouncer"], 
    content => template("mydevops_postgresql_repmgr/pgbouncer.ini.erb"),
    notify  => Service["pgbouncer"],
  }
 }
}

define mydevops_postgresql_repmgr::pgbouncer::users($userlist=[]) { 

 $pgbouncerusers = $userlist
 
 file { "/etc/pgbouncer/userlist.txt":
   ensure => present,
   require => Package["pgbouncer"],
   content => template("mydevops_postgresql_repmgr/userlist.txt.erb"),
   notify  => Service["pgbouncer"],
 }
 
}
