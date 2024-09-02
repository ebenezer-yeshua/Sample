class mydevops_blog::staging_web_qa($blogweb=true) {

if $blogweb {
   
      include mydevops_blog::staging_web_qa::blogweb
   
  } else {
  
    notify {'Cam stage web setup seems disabled':}
    
  }
}

class mydevops_blog::staging_web_qa::blogweb {

class { 'nginx::config' :
    worker_processes => auto,
    nginx_cfg_prepend => { 'include' => '/etc/nginx/modules-enabled/*.conf' }
  }
  
class { 'nginx' :  }

$deppackges = ['libnginx-mod-http-passenger', 'memcached', 'libmemcached-tools']
package { $deppackges:
    ensure => present,
 }

nginx::resource::vhost { 'qa-accounts.mydevops.od.ua-no-ssl':
  ensure        => present,
  server_name   => ['qa-accounts.mydevops.od.ua'],
  listen_ip     => '10.0.1.177',
  listen_port   => '80',
  www_root      => '/home/sites/accounts.mydevops.com/public',
  rewrite_to_https => true,
  error_log     => '/var/log/nginx/error.log'
}

nginx::resource::vhost { 'qa-accounts.mydevops.od.ua-ssl':
  ensure        => present,
  server_name   => ['qa-accounts.mydevops.od.ua'],
  listen_ip     => '10.0.1.177',
  listen_port   => '443',
  vhost_cfg_ssl_prepend => {
   'passenger_ruby' => '/usr/local/rvm/wrappers/ruby-2.6.2@blog5/ruby',
   'passenger_enabled' => 'on',
   'passenger_app_env' => 'stage',
   'passenger_start_timeout' => '240'
  },
  use_default_location => false,
  ssl           => true,
  ssl_cert      => '/etc/nginx/ssl/qa-accounts.mydevops.od.ua/qa-accounts_mydevops_od_ua.crt',
  ssl_key       => '/etc/nginx/ssl/qa-accounts.mydevops.od.ua/qa-accounts_mydevops_od_ua.key',
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
    'rewrite' => [ '^/mydevopslive/management/downloadpage  http://www.mydevopslive.com/download.php permanent', '^/download/trustconnect/(.*)$  http://download.mydevops.com/trustconnect/$1 permanent' ],
    'add_header' => [ 'Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"', 'Content-Security-Policy "default-src \'self\'; script-src \'self\' \'unsafe-inline\' \'unsafe-eval\' data: https://ads.bridgetrack.com https://ssl.google-analytics.com https://www.google-analytics.com https://ajax.googleapis.com https://cdnjs.cloudflare.com https://script.hotjar.com https://static.hotjar.com https://plugins.help.com https://maxcdn.bootstrapcdn.com https://secure.mydevops.net https://www.mydevopslogo.com https://secure.mydevops.com https://cdn.optimizely.com https://www.google.com https://www.gstatic.com ; style-src \'self\' \'unsafe-inline\' https://maxcdn.bootstrapcdn.com https://cdnjs.cloudflare.com https://fonts.googleapis.com ; font-src \'self\' https://maxcdn.bootstrapcdn.com https://fonts.gstatic.com ; img-src \'self\' data: https://stats.g.doubleclick.net https://secure.mydevops.com https://www.google-analytics.com https://www.mydevopslogo.com https://ssl.google-analytics.com ; child-src https://blog.mydevops.com https://plugins.help.com https://vars.hotjar.com https://www.mydevopslogo.com https://secure.mydevops.net https://secure.mydevops.com https://www.youtube.com https://www.google.com ; object-src \'self\' https://secure.mydevops.net https://secure.mydevops.com https://www.youtube.com ; connect-src \'self\' https://accounts.mydevops.com https://insights.hotjar.com ; report-uri https://cspreports.mydevops.com; frame-ancestors https://blog.mydevops.com"',  'X-Content-Type-Options "nosniff" always', 'X-Frame-Options SAMEORIGIN always' ],
  },

  gzip_types => 'application/javascript application/rss+xml application/vnd.ms-fontobject application/x-font application/x-font-opentype application/x-font-otf application/x-font-truetype application/x-font-ttf application/x-javascript application/xhtml+xml application/xml font/opentype font/otf font/ttf image/svg+xml image/x-icon text/css text/javascript text/plain text/xml',
  error_log     => '/var/log/nginx/error.log'
  }

 nginx::resource::location { '/cable':
    ensure   => present,
    location => '/cable',
    vhost    => 'qa-accounts.mydevops.od.ua-ssl',
    ssl           => true,
    ssl_only      => true,
    location_custom_cfg => {
      'passenger_app_group_name'  => 'blog_action_cable',
      'passenger_force_max_concurrent_requests_per_process'  => '0'
    }
  }
  
 file { '/etc/nginx/ssl':
    ensure => 'directory'
 } 
 file {
   'ssl crt and key files':
    ensure => 'directory',
    source => 'puppet:///modules/mydevops_blog/ssl/qa-accounts.mydevops.od.ua',
    recurse => true,
    path => '/etc/nginx/ssl/qa-accounts.mydevops.od.ua',
   }
}
