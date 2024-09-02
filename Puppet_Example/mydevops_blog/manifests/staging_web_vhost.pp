#
define mydevops_blog::staging_web_vhost(
$ssl
) {
  $ssl_key="/etc/nginx/${name}.key"
  $ssl_cert="/etc/nginx/${name}.crt"
  $ssl_dhparam="/etc/nginx/${name}.dh2048.pem"
  if $ssl_redirect {
    $rewrite_to_https=true
  } else {
    $rewrite_to_https=false
  }
  $vhost_ssl=true
  ssl_certificates::dhparam{"/etc/nginx/${name}.dh2048.pem":
  }
  ssl_certificates::crt{$name:
    domain   => $ssl,
    key      => $ssl_key,
    combined => $ssl_cert,
  }


  nginx::resource::vhost { "${name}-no-ssl":
    ensure        => present,
    server_name   => ["${name}"],
    listen_ip     => '10.0.1.25',
    listen_port   => '80',
    www_root      => '/home/sites/accounts.mydevops.com/public',
    rewrite_to_https => true,
    error_log     => '/var/log/nginx/error.log'
  }

  nginx::resource::vhost { "${name}-ssl":
    ensure        => present,
    server_name   => ["${name}"],
    listen_ip     => '10.0.1.25',
    listen_port   => '443',
    vhost_cfg_ssl_prepend => {
     'passenger_ruby' => '/usr/local/rvm/wrappers/ruby-2.6.2@blog5/ruby',
     'passenger_enabled' => 'on',
     'passenger_app_env' => 'stage',
     'passenger_start_timeout' => '240'
    },
    use_default_location => false,
    ssl           => $vhost_ssl,
    ssl_cert      => $ssl_cert,
    ssl_key       => $ssl_key,
    ssl_dhparam   => $ssl_dhparam,
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

  nginx::resource::location { "${name}":
    ensure   => present,
    location => '/cable',
    vhost    => "${name}-ssl",
    ssl           => true,
    ssl_only      => true,
    location_custom_cfg => {
      'passenger_app_group_name'  => 'blog_action_cable',
      'passenger_force_max_concurrent_requests_per_process'  => '0'
    }
  }
}
