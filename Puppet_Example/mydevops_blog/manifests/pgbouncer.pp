class mydevops_blog::pgbouncer($blogpgbouncer=true) {

if $blogpgbouncer {
  
      include mydevops_blog::pgbouncer::blogpgbouncer
    
  } else {
  
      notify {'Cam pgbouncer setup disabled':}
  }   
}

class mydevops_blog::pgbouncer::blogpgbouncer {

package { "pgbouncer": ensure => installed, }
service { "pgbouncer": ensure  => "running", enable  => "true", require => Package["pgbouncer"], }
 file { "/etc/default/pgbouncer":
    ensure => "present",
    require => Package["pgbouncer"],
    notify  => Service["pgbouncer"],
 }
 sudo::conf { 'postgres':
    ensure  => present,
    content => 'postgres ALL=(ALL) NOPASSWD: /etc/init.d/pgbouncer',
 }
 $pgbouncerdb = []
 file { "/etc/pgbouncer":
   ensure => present,
   owner  => 'postgres',
   group  => 'postgres',
 }
 file { "/etc/pgbouncer/pgbouncer.ini":
   ensure => present,
   require => Package["pgbouncer"], 
   content => template("mydevops_blog/pgbouncer.ini.erb"),
   notify  => Service["pgbouncer"],
 }
 $pgbouncerusers = [
   { user => "postgres", md5 => "md5084bb887d7390748d9abd99afbd93020", },
   { user => "sasp", md5 => "md5f9674d70904b3a797688ed4a6e667b47", },
   { user => "pgbouncer", md5 => "md5ca21e4145fa5a4929bb478891d2271a0", },
 ]
 file { "/etc/pgbouncer/userlist.txt":
   ensure => present,
   require => Package["pgbouncer"],
   content => template("mydevops_blog/userlist.txt.erb"),
   notify  => Service["pgbouncer"],
 }

  telegraf::input{'pgbouncer':
    plugin_type => 'pgbouncer',
    options     => [{
      address     => 'user=pgbouncer password=uSainooSudoomahl7IN dbname=pgbouncer'
    }]
  }

}
