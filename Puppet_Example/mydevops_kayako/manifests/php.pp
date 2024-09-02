class mydevops_kayako::php {

 class { '::php::globals':
   php_version => '5.6',
 }->
 class { '::php':
   manage_repos => false,
   fpm          => true,
   dev          => true,
   composer     => true,
   pear         => true,
   settings   => lookup('mydevops_kayako::php::settings'),
   extensions => lookup('mydevops_kayako::php::extensions')
 }

}
