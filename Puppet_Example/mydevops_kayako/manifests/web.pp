class mydevops_kayako::web($kayakoweb=true) {

if $kayakoweb {
 
     include mydevops_kayako::web::kayakoweb
 
} else {

      notify {'Kayako web setup has been disabled':}
  }
}

class mydevops_kayako::web::kayakoweb {

class {'apache':
  apache_version => '2.4',
  user => 'kayako',
  group => 'kayako',
  default_vhost => false,
  mpm_module => false,
}

class {
  'apache::mod::prefork':
    startservers    => "2",
    serverlimit     => "10",
    minspareservers => "8",
    maxspareservers => "16",
    maxclients   => "250",
    maxrequestsperchild  => "500",
}

class {'::apache::mod::php':
   php_version => '5.6'
}

  apache::listen { '80': }
  apache::listen { '443': }


class { 'apache::mod::ssl':
  ssl_cipher   => 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:!ECDHE-ECDSA-DES-CBC3-SHA:!ECDHE-RSA-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:!DES-CBC3-SHA:!DSS',
  ssl_honorcipherorder => on,
  ssl_compression => false,
}

class { 'apache::mod::status':
      allow_from      => ['127.0.0.1','::1'],
      extended_status => 'On',
      status_path     => '/server-status',
  }

class { 'apache::mod::headers': }

apache::vhost { 'support.mydevops.com-nonssl':
  ip              => '10.165.10.42',
  priority        => '01',
  servername      => 'support.mydevops.com',
  serveraliases => 'support.trustfax.com',
  port            => '80',
  docroot         => '/www/support.mydevops.com',
  rewrites => [
        {
          rewrite_cond => ['%{QUERY_STRING} ^_m=knowledgebase&_a=viewarticle&kbarticleid=1025$'],
          rewrite_rule => ['^/index.php$ https://support.mydevops.com/index.php?/Default/Knowledgebase/Article/View/485/0/ [L,R=301]', '^/firewall http://personalfirewall.mydevops.com/support.html [L,R=301]'],
        },
        {
          rewrite_cond => ['%{HTTPS} off', '%{REMOTE_ADDR} !192.168'],
          rewrite_rule => ['^(.*) https://%{HTTP_HOST}%{REQUEST_URI}'],
        },
        {
          comment =>  'FXR-733-90789',
          rewrite_cond => ['%{REQUEST_URI}  !support.mydevops.com'],
          rewrite_rule => ['^/(.*)$ https://support.mydevops.com/$2 [R=301,L]'],
        },
   ],
  ip_based        => true,
  add_listen      => false,
  access_log_file => 'support.mydevops.com_log'
}

apache::vhost { 'support.mydevops.com-ssl':
  ip         => '10.165.10.42',
  priority   => '02',
  servername => 'support.mydevops.com',
  serveraliases => 'support.trustfax.com',
  port       => '443',
  docroot    => '/www/support.mydevops.com',
  access_log_file => 'support.mydevops.com_log',
  directories => [
    { path => '\.(js|css|pdf|txt|gif|jpg|jpeg|png|ico|swf)$', 'provider' => 'files', headers => 'set Cache-Control \"max-age=86400\"' },
    { path => '^/(admin|__swift/logs)', 'provider' => 'location', 'deny' => 'from all' }  
  ],
   ssl        => true,
   ssl_cert => '/etc/apache2/ssl/support.mydevops.com/support_mydevops_com.crt',
   ssl_key  => '/etc/apache2/ssl/support.mydevops.com/support_mydevops_com.key',
   ssl_chain => '/etc/apache2/ssl/support.mydevops.com/support_mydevops_com.ca-bundle',
   ssl_certs_dir => '/etc/apache2/ssl/support.mydevops.com',
   ip_based   => true,
   add_listen => false,
   headers => [ "add Strict-Transport-Security \"max-age=15768000\"", "unset \"X-Powered-By\"", "always set X-Frame-Option \"SAMEORIGIN\"", "always set X-Content-Type-Options \"nosniff\"", "always set X-Xss-Protection \"1; mode=block\"", "set Content-Security-Policy \"default-src 'self'; script-src 'self' 'unsafe-eval' 'unsafe-inline' https://plugins.help.com https://www.google-analytics.com ; style-src 'self' 'unsafe-inline' ; font-src 'self' 'unsafe-inline' https://fonts.gstatic.com ; img-src data: 'self' https://www.google-analytics.com ; object-src 'self'; connect-src 'self' ; frame-src https://plugins.help.com ; report-uri https://cspreports.mydevops.com\"" ],
   request_headers => [ "set X_FORWARDED_PROTO 'https'" ],
   rewrite_inherit => on,
   rewrites => [
        { 
          comment      => 'IZV-115-59133',
          rewrite_cond => ['%{QUERY_STRING} ^/Default/(.*) [NC]'],
          rewrite_rule => ['^/index.php$ %{REQUEST_FILENAME}?/mydevops/%1 [R=301]'],
        },
        {
          comment      => 'FXR-733-90789',
          rewrite_cond => ['%{HTTP_HOST} !support.mydevops.com'],
          rewrite_rule => ['^(.*)$ https://support.mydevops.com/$2 [R=301,L]'],
        },
        {
          rewrite_cond => ['%{QUERY_STRING} ^_m=tickets&_a=viewticket&ticketid=([0-9]+)'],
          rewrite_rule => ['^(/staff)?/index.php$ $1/index.php?/Tickets/Ticket/View/%1 [L,R=301]'],
        },
        {
          comment      => 'whiz bang v3 knowledge base link to v4 knowledgebase link - yeah they could go on one line, but this is more readable',
          rewrite_cond => ['%{QUERY_STRING} ^_m=knowledgebase&_a=viewarticle&kbarticleid=([0-9]+)', '%{QUERY_STRING} ^_m=knowledgebase&_a=printable&kbarticleid=([0-9]+) [OR]' , '%{QUERY_STRING} ^_a=viewarticle&_m=knowledgebase&kbarticleid=([0-9]+) [OR]', '%{QUERY_STRING} ^_m=downloads&_a=viewdownload&downloaditemid=([0-9]+) [OR]'],
          rewrite_rule => ['^/index.php$ /kbredirect/getarticle.php?kbarticleid=%1 [L,R=301]'],
        },
        {
          comment      => 'now the getarticle script handles categories too.',  
          rewrite_cond => ['%{QUERY_STRING} ^_m=knowledgebase&_a=view&parentcategoryid=([0-9]+)'],
          rewrite_rule => ['^/index.php$ /kbredirect/getarticle.php?kbcatid=%1 [L,R=301]'],
        },
        {
          comment      => 'some download category links',
          rewrite_cond => ['%{QUERY_STRING} ^_m=downloads&_a=view&parentcategoryid=14'],
          rewrite_rule => ['^/index.php$ /index.php?/Default/Knowledgebase/Article/View/821/37/certificate-installation-cobalt-raq4 [L,R=301]'],
        },
        {
          rewrite_cond => ['%{QUERY_STRING} ^_m=downloads&_a=view&parentcategoryid=1'],
          rewrite_rule => ['^/index.php$ /index.php?/Default/Knowledgebase/List/Index/75/instantsslenterprisesslintranetssl [L,R=301]'],
        },
        {
          comment      => 'EV SSL Certs - TICKET ID GVW-544-79174',
          rewrite_cond => ['%{QUERY_STRING} ^_m=downloads&_a=viewdownload&downloaditemid=59'],
          rewrite_rule => ['^/index.php$ /index.php?/Default/Knowledgebase/Article/View/892 [L,R=301]'],
        },        
        {
          comment      => 'GOY-683-88712 Suggestion- Broken link removal',
          rewrite_cond => ['%{QUERY_STRING} ^/Default/Knowledgebase/Article/View/1184/66/ms-smartscreen-and-application-reputation'],
          rewrite_rule => ['^/(.*)$ http://windows.microsoft.com/en-us/windows7/smartscreen-filter-frequently-asked-questions-ie9  [L,R=301]'],
        },
        {
          rewrite_cond => ['%{QUERY_STRING} ^_m=downloads&_a=viewdownload&downloaditemid=69'],
          rewrite_rule => ['^/index.php$ /index.php?/Default/Knowledgebase/Article/View/902 [L,R=301]'],
        },

      ],
     setenvif => 'Remote_Addr .* no-gzip', 
     custom_fragment => '
     AddOutputFilterByType DEFLATE text/html text/plain text/css text/xml application/xml application/xhtml+xml text/javascript application/x-javascript
     BrowserMatch ^Mozilla/4 gzip-only-text/html
     BrowserMatch ^Mozilla/4.0[678] no-gzip
     BrowserMatch \bMSIE !no-gzip !gzip-only-text/html'
   }

   file {
   'ssl crt and key files':
    ensure => 'directory',
    source => 'puppet:///modules/mydevops_kayako/ssl/support.mydevops.com',
    recurse => true,
    path => '/etc/apache2/ssl/support.mydevops.com',
   }

}

