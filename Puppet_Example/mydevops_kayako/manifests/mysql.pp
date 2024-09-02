class mydevops_kayako::mysql($kayakodb=true) {

if $kayakodb {

    include mydevops_kayako::mysql::kayakodb
 
} else {
    
     notify {'Kayako db setup disabled':}
 }

}

## [KAYAKO DB CONFIG] ##

class mydevops_kayako::mysql::kayakodb {

$override_options = lookup(mydevops_kayako::mysql::override_options)

class {'::mysql::server':
  package_name     => lookup(mydevops_kayako::mysql::package_name),
  package_ensure   => lookup(mydevops_kayako::mysql::package_ensure),
  service_name     => lookup(mydevops_kayako::mysql::service_name),
  root_password    => lookup(mydevops_kayako::mysql::root_password),
  override_options => $override_options
  }

create_resources(mysql::db, lookup('mydevops_kayako::mysql::db', {}))

}

## [END] ##
