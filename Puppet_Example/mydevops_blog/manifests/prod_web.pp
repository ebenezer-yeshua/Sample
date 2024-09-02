class mydevops_blog::prod_web($blogweb=true) {

if $blogweb {
    
      include mydevops_blog::prod_web::blogweb
      
  } else {
  
    notify {'blog web setup seems disabled':}
    
  }
}

class mydevops_blog::prod_web::blogweb {

sudo::conf { 'sites':
    ensure  => present,
    content => 'sites ALL=(ALL) NOPASSWD: /etc/init.d/nginx',
 }

class { 'nginx::config' :
    worker_processes => auto,
    nginx_cfg_prepend => { 'include' => '/etc/nginx/modules-enabled/*.conf' }
  }
  
class { 'nginx' :  }

$deppackges = ['libnginx-mod-http-passenger', 'memcached', 'libmemcached-tools']
package { $deppackges:
    ensure => present,
 }
 
 nginx::resource::vhost { 'localhost':
  ensure        => present,
  server_name   => ['localhost'],
  listen_ip     => '127.0.0.1',
  listen_port   => '80',
  www_root      => '/var/www'
}

nginx::resource::vhost { 'logview':
  ensure        => present,
  listen_ip     => '*',
  listen_port   => '80',
  use_default_location => false,
  www_root      => '/home/sites/accounts.mydevops.com/logs',
  vhost_cfg_append => {
   'rewrite' => [ '^/Logview(.*)$ /home/sites/accounts.mydevops.com/logs/$1  permanent', '^/Nginxlogview(.*)$ /var/log/nginx/$1  permanent' ]
  },
}
nginx::resource::location { '/home/sites/accounts.mydevops.com/logs':
    ensure   => present,
    location => '/home/sites/accounts.mydevops.com/logs',
    vhost    => 'logview',
    location_custom_cfg => {
      'allow'  => '10.0.0.0/8',
      'deny'  => 'all'
  }
}
nginx::resource::location { '/var/log/nginx':
    ensure   => present,
    location => '/var/log/nginx',
    vhost    => 'logview',
    location_custom_cfg => {
      'allow'  => '10.0.0.0/8',
      'deny'  => 'all'
  }
}

nginx::resource::vhost { 'accounts.mydevops.com-no-ssl':
  ensure        => present,
  server_name   => ['accounts.mydevops.com'],
  listen_ip     => '10.0.1.55',
  listen_port   => '80',
  www_root      => '/home/sites/accounts.mydevops.com/public',
  rewrite_to_https => true
}

nginx::resource::vhost { 'accounts.mydevops.com-ssl':
   ensure                    => present,
   server_name               => ['accounts.mydevops.com'],
   listen_ip                 => '10.0.1.55',
   listen_port               => '443',
   vhost_cfg_ssl_prepend     => {
   'passenger_ruby'          => '/usr/local/rvm/wrappers/ruby-2.6.2@blog5/ruby',
   'passenger_enabled'       => 'on',
   'passenger_app_env'       => 'production',
   'passenger_start_timeout' => '300',
   'passenger_max_requests'  =>  30000,
  },
   use_default_location      => false,
   ssl                       => true,
   ssl_cert                  => '/etc/nginx/ssl/accounts.mydevops.com/accounts_mydevops_com.crt',
   ssl_key                   => '/etc/nginx/ssl/accounts.mydevops.com/accounts_mydevops_com.key',
   www_root                  => '/home/sites/accounts.mydevops.com/public',
   vhost_cfg_ssl_append      => { 
    ''  => 'if (-f /var/www/html/outage.txt) {
    
    rewrite ^/signup_service/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/request_api/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/reseller/signup_service/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/sso/(.*) https://$host$request_uri?maintenance=1 permanent;

    rewrite  ^(.*)$  /maintenance.html last;
    break;

    }
    #Addheader and Rewrite',
    'rewrite' => [ '^/mydevops/management/downloadpage  http://www.mydevops.in/download.php permanent', '^/download/trustconnect/(.*)$  http://download.mydevops.com/trustconnect/$1 permanent' ],
    'add_header' => [ 'Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"', 'Content-Security-Policy "default-src \'self\'; script-src \'self\' \'unsafe-inline\' \'unsafe-eval\' data: https://ads.bridgetrack.com https://ssl.google-analytics.com https://www.google-analytics.com https://ajax.googleapis.com https://cdnjs.cloudflare.com https://script.hotjar.com https://static.hotjar.com https://plugins.help.com https://maxcdn.bootstrapcdn.com https://secure.mydevops.net https://www.trustlogo.com https://secure.mydevops.com https://cdn.optimizely.com https://www.google.com https://www.gstatic.com ; style-src \'self\' \'unsafe-inline\' https://maxcdn.bootstrapcdn.com https://cdnjs.cloudflare.com https://fonts.googleapis.com ; font-src \'self\' https://maxcdn.bootstrapcdn.com https://fonts.gstatic.com ; img-src \'self\' data: https://stats.g.doubleclick.net https://secure.mydevops.com https://www.google-analytics.com https:/www.mydevops.in https://ssl.google-analytics.com ; child-src https://blog.mydevops.com https://plugins.help.com https://vars.hotjar.com https://www.trustlogo.com https://secure.mydevops.net https://secure.mydevops.com https://www.youtube.com https://www.google.com ; object-src \'self\' https://secure.mydevops.net https://secure.mydevops.com https://www.youtube.com ; connect-src \'self\' https://accounts.mydevops.com https://insights.hotjar.com ; report-uri https://cspreports.mydevops.com; frame-ancestors https://blog.mydevops.com"',  'X-Content-Type-Options "nosniff" always', 'X-Frame-Options SAMEORIGIN always' ],
  },

   gzip_types                => 'application/javascript application/rss+xml application/vnd.ms-fontobject application/x-font application/x-font-opentype application/x-font-otf application/x-font-truetype application/x-font-ttf application/x-javascript application/xhtml+xml application/xml font/opentype font/otf font/ttf image/svg+xml image/x-icon text/css text/javascript text/plain text/xml'
  }

nginx::resource::location { '/cable':
    ensure   => present,
    location => '/cable',
    vhost    => 'accounts.mydevops.com-ssl',
    ssl           => true,
    ssl_only      => true,
    location_custom_cfg => {
      'passenger_app_group_name'  => 'blog_action_cable',
      'passenger_force_max_concurrent_requests_per_process'  => '0'
  }
}

nginx::resource::vhost { 'pre-accounts.mydevops.com-ssl':
  ensure        => present,
  server_name   => ['pre-accounts.mydevops.com'],
  listen_ip     => '162.255.25.55',
  listen_port   => '443',
  vhost_cfg_ssl_prepend => {
   'passenger_ruby' => '/usr/local/rvm/wrappers/ruby-2.6.2@blog5/ruby',
   'passenger_enabled' => 'on',
   'passenger_app_env' => 'production',
   'passenger_start_timeout' => '300'
  },
  use_default_location => false,
  ssl           => true,
  ssl_cert      => '/etc/nginx/ssl/pre-accounts.mydevops.com/pre-accounts_mydevops_com.crt',
  ssl_key       => '/etc/nginx/ssl/pre-accounts.mydevops.com/pre-accounts_mydevops_com.key',
  www_root      => '/home/sites/accounts.mydevops.com/public',
  vhost_cfg_ssl_append => { 
    ''  => 'if (-f /var/www/html/outage.txt) {
    
    rewrite ^/signup_service/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/request_api/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/reseller/signup_service/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/sso/(.*) https://$host$request_uri?maintenance=1 permanent;

    rewrite  ^(.*)$  /maintenance.html last;
    break;

    }
    #Addheader and Rewrite',
    'rewrite' => [ '^/mydevops/management/downloadpage  http://www.mydevops.in/download.php permanent', '^/download/trustconnect/(.*)$  http://download.mydevops.com/trustconnect/$1 permanent' ],
    'add_header' => [ 'Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"', 'Content-Security-Policy "default-src \'self\'; script-src \'self\' \'unsafe-inline\' \'unsafe-eval\' data: https://ads.bridgetrack.com https://ssl.google-analytics.com https://www.google-analytics.com https://ajax.googleapis.com https://cdnjs.cloudflare.com https://script.hotjar.com https://static.hotjar.com https://plugins.help.com https://maxcdn.bootstrapcdn.com https://secure.mydevops.net https://www.trustlogo.com https://secure.mydevops.com https://cdn.optimizely.com https://www.google.com https://www.gstatic.com ; style-src \'self\' \'unsafe-inline\' https://maxcdn.bootstrapcdn.com https://cdnjs.cloudflare.com https://fonts.googleapis.com ; font-src \'self\' https://maxcdn.bootstrapcdn.com https://fonts.gstatic.com ; img-src \'self\' data: https://stats.g.doubleclick.net https://secure.mydevops.com https://www.google-analytics.com https://www.trustlogo.com https://ssl.google-analytics.com ; child-src https://blog.mydevops.com https://plugins.help.com https://vars.hotjar.com https://www.trustlogo.com https://secure.mydevops.net https://secure.mydevops.com https://www.youtube.com https://www.google.com ; object-src \'self\' https://secure.mydevops.net https://secure.mydevops.com https://www.youtube.com ; connect-src \'self\' https://accounts.mydevops.com https://insights.hotjar.com ; report-uri https://cspreports.mydevops.com; frame-ancestors https://blog.mydevops.com"',  'X-Content-Type-Options "nosniff" always', 'X-Frame-Options SAMEORIGIN always' ],
  },

  gzip_types => 'application/javascript application/rss+xml application/vnd.ms-fontobject application/x-font application/x-font-opentype application/x-font-otf application/x-font-truetype application/x-font-ttf application/x-javascript application/xhtml+xml application/xml font/opentype font/otf font/ttf image/svg+xml image/x-icon text/css text/javascript text/plain text/xml'
  }

nginx::resource::location { '/cable pre':
    ensure   => present,
    location => '/cable',
    vhost    => 'pre-accounts.mydevops.com-ssl',
    ssl           => true,
    ssl_only      => true,
    location_custom_cfg => {
      'passenger_app_group_name'  => 'blog_action_cable',
      'passenger_force_max_concurrent_requests_per_process'  => '0'
  }
}


nginx::resource::vhost { 'accounts.mydevops.com-no-ssl':
  ensure        => present,
  server_name   => ['accounts.mydevops.com'],
  listen_ip     => '10.0.1.55',
  listen_port   => '80',
  www_root      => '/home/sites/accounts.mydevops.com/public',
  rewrite_to_https => true
}

nginx::resource::vhost { 'accounts.mydevops.com-ssl':
  ensure        => present,
  server_name   => ['accounts.mydevops.com'],
  listen_ip     => '10.0.1.55',
  listen_port   => '443',
  vhost_cfg_ssl_prepend => {
   'passenger_ruby' => '/usr/local/rvm/wrappers/ruby-2.6.2@blog5/ruby',
   'passenger_enabled' => 'on',
   'passenger_app_env' => 'production'
  },
  use_default_location => false,
  ssl           => true,
  ssl_cert      => '/etc/nginx/ssl/accounts.mydevops.com/accounts_mydevops_com.crt',
  ssl_key       => '/etc/nginx/ssl/accounts.mydevops.com/accounts_mydevops_com.key',
  www_root      => '/home/sites/accounts.mydevops.com/public',
  vhost_cfg_ssl_append => { 
    ''  => 'if (-f /var/www/html/outage.txt) {
    
    rewrite ^/signup_service/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/request_api/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/reseller/signup_service/(.*) https://$host$request_uri?maintenance=1 permanent;
    rewrite ^/sso/(.*) https://$host$request_uri?maintenance=1 permanent;

    rewrite  ^(.*)$  /maintenance.html last;
    break;

    }
    #Addheader and Rewrite',
   'rewrite' => [ '^/mydevops/management/downloadpage  http://www.mydevops.com/download.php permanent', '^/download/trustconnect/(.*)$  http://download.mydevops.com/trustconnect/$1 permanent' ],
   'add_header' => [ 'Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"', 'Content-Security-Policy upgrade-insecure-requests' ],
   },

   gzip_types => 'application/javascript application/rss+xml application/vnd.ms-fontobject application/x-font application/x-font-opentype application/x-font-otf application/x-font-truetype application/x-font-ttf application/x-javascript application/xhtml+xml application/xml font/opentype font/otf font/ttf image/svg+xml image/x-icon text/css text/javascript text/plain text/xml'
   }
   
 file { '/etc/nginx/ssl':
    ensure => 'directory'
 }    
 file {
   'ssl crt and key files of accounts.mydevops.com':
    ensure => 'directory',
    source => 'puppet:///modules/mydevops_blog/ssl/accounts.mydevops.com',
    recurse => true,
    path => '/etc/nginx/ssl/accounts.mydevops.com',
   }
   file {
   'ssl crt and key files of pre-accounts.mydevops.com':
    ensure => 'directory',
    source => 'puppet:///modules/mydevops_blog/ssl/pre-accounts.mydevops.com',
    recurse => true,
    path => '/etc/nginx/ssl/pre-accounts.mydevops.com',
   }
  file {
   'ssl crt and key files of accounts.mydevops.com':
    ensure => 'directory',
    source => 'puppet:///modules/mydevops_blog/ssl/accounts.mydevops.com',
    recurse => true,
    path => '/etc/nginx/ssl/accounts.mydevops.com',
   }

  sudo::conf{'telegraf_passenger_status':
    priority => 10,
    content  => 'telegraf ALL= (root) NOPASSWD: /usr/sbin/passenger-status -v --show=xml',
  }
  include mydevops_telegraf::monitor
  telegraf::input{'passenger':
    plugin_type => 'passenger',
    options     => [{
      command => '/usr/bin/sudo /usr/sbin/passenger-status -v --show=xml'
    }]
  }

  nginx::resource::location{"stub-status":
    ensure      => present,
    vhost       => "localhost",
    stub_status => true,
    location    => '/stub-status',
  }
  include mydevops_telegraf::monitor
  telegraf::input{'nginx':
    plugin_type => 'nginx',
      options   => [{
        'urls'   => ['http://127.0.0.1/stub-status']
      }]
  }

  telegraf::input{"blog_login":
    plugin_type => "http_response",
    options     => [{
      address => "https://accounts.mydevops.com/login",
    }]
  }
}
