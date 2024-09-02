class mydevops_blog::prod_ruby($blogruby=true) {

if $blogruby {
   
  include mydevops_blog::prod_ruby::blogruby

   } else {
   
    notify {'Cam ruby setup seems disabled':}
    
  }

}

class mydevops_blog::prod_ruby::blogruby {

 $dependencies = ['ruby-dev','libxml2-dev','libxslt1-dev', 'libsasl2-dev', 'libpq-dev', 'liblzma-dev', 'apache2-dev', 'libxrender1']
 package { $dependencies:
   ensure => present,
 }

 class { '::nodejs':
   manage_package_repo   => false,
   repo_class            => '::epel',
   repo_url_suffix       => '10.x',
 }

 Rvm_system_ruby {
   ensure     => present,
 }
 
 exec {"import gpg key for RVM":
   command => "curl -sSL https://rvm.io/mpapis.asc | gpg --import -; curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -",
   provider => shell,
   unless => "test $(gpg --list-keys | egrep '7D2BAF1CF37B13E2069D6956105BD0E739499BDB|409B6B1796C275462A1703113804BB82D39DC0E3' | wc -l) -eq 2"
  } 

class { '::rvm': gnupg_key_id => false }
 
 group { 'sites': }

 rvm::system_user { 'sites': }
 
 file { '/home/sites':
    ensure => 'directory',
    owner  => 'sites',
    group  => 'sites',
 }

 rvm_system_ruby {
  'ruby-2.6.2':
    default_use => true;
 }

rvm_gemset {
  'ruby-2.6.2@blog5':
    ensure  => present,
    require => Rvm_system_ruby['ruby-2.6.2'];
 } ~>
 exec{'wrapper':
   command => '/usr/local/rvm/bin/rvm wrapper regenerate',
   unless => '/usr/bin/test -f /usr/local/rvm/wrappers/ruby-2.6.2@blog5/ruby'
 }

rvm_gem {
  'ruby-2.6.2@blog5/rails':
    ensure  => '5.2.4',
    source => 'https://rubygems.org',
    require => Rvm_gemset['ruby-2.6.2@blog5'];
 } 

}

