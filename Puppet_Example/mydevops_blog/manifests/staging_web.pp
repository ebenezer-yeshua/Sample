class mydevops_blog::staging_web($blogweb=true) {

if $blogweb {
   
      include mydevops_blog::staging_web::blogweb
   
  } else {
  
    notify {'Cam stage web setup seems disabled':}
    
  }
}

class mydevops_blog::staging_web::blogweb {

class { 'nginx::config' :
    worker_processes => auto,
    nginx_cfg_prepend => { 'include' => '/etc/nginx/modules-enabled/*.conf' }
  }
  
class { 'nginx' :  }

$deppackges = ['libnginx-mod-http-passenger', 'memcached', 'libmemcached-tools']
package { $deppackges:
    ensure => present,
 }

mydevops_blog::staging_web_vhost{"accounts.mydevops.od.ua":
ssl => "accounts.mydevops.od.ua"
}

mydevops_blog::staging_web_vhost{"accounts-staging.mydevops.com":
ssl => "mydevops.com"
}
  
mydevops_blog::staging_web_vhost{"accounts-staging.mydevops.com":
ssl => "mydevops.com"
}
mydevops_blog::staging_web_vhost{"accounts-staging.mydevops.com":
ssl => "mydevops.com"
}

}

