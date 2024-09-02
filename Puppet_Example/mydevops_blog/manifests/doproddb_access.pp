class mydevops_blog::doproddb_access ($nodeid=undef) {

 include mydevops_firewall

 class {'mydevops_blog::doprod_db':
      nodeid => $nodeid,
      nodename => $fqdn,
      webhost => '10.0.1.9 10.0.1.113 10.0.1.47 10.0.1.62',
      pgdb => 'mydevops_sasp'
 }

  mydevops_firewall::permit{'ssh permit web1-blog-prod-virt-nyc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.152'
  }
  mydevops_firewall::permit{'ssh permit kmd':
    chain   => ssh,
    address => '10.0.1.4'
  }
  mydevops_firewall::permit{'ssh permit db1-blog-prod-virt-nyc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.143'
  }
  mydevops_firewall::permit{'ssh permit db2-blog-prod-virt-sjc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.13'
  }
  mydevops_firewall::permit{'ssh permit db3-blog-prod-virt-nyc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.219'
  }
  mydevops_firewall::permit{'ssh permit db4-blog-prod-virt-sjc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.191'
  } 
  mydevops_firewall::permit{'ssh permit db5-blog-prod-virt-sjc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.113'
  } 
  mydevops_firewall::permit{'ssh permit postgres cluster pair':
    chain   => ssh,
    address => '10.0.1.13'
  }
  mydevops_firewall::permit{'ssh permit postgres backup server':
    chain   => ssh,
    address => '10.0.1.134'
  }

mydevops_blog::db::permit{"replication":
    dbuser   => 'repmgr',
    dbname   => 'replication',
    dbauth   => 'trust',
     allow   => [
      {
        address     => '10.0.1.143/32',
        description => 'db1-blog-prod-virt-nyc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.13/32',
        description => 'db2-blog-prod-virt-sjc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.219/32',
        description => 'db3-blog-prod-virt-nyc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.191/32',
        description => 'db4-blog-prod-virt-sjc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.113/32',
        description => 'db5-blog-prod-virt-sjc3.mydevopscdn.com'
      },
      {
        address     => '127.0.0.1/32',
        description => 'Replication allow localhost'
      }
    ]
  }
  
mydevops_blog::db::permit{"repmgr":
    dbuser     => 'repmgr',
    dbname    => 'repmgr',
    dbauth   => 'trust',
    local    => true,
     allow   => [
      {
        address     => '10.0.1.143/32',
        description => 'db1-blog-prod-virt-nyc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.13/32',
        description => 'db2-blog-prod-virt-sjc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.219/32',
        description => 'db3-blog-prod-virt-nyc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.191/32',
        description => 'db4-blog-prod-virt-sjc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.113/32',
        description => 'db5-blog-prod-virt-sjc3.mydevopscdn.com'
      }
    ]
  }
  
mydevops_blog::db::permit{"web access":
    dbuser     => 'sasp',
    dbname    => 'mydevops_sasp',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '10.0.1.11/32',
        description => 'blog1-web-virt-ewr1.mydevopscdn.com'
      },
      {
        address     => '10.0.1.82/32',
        description => 'blog1-web-virt-sjc1.mydevopscdn.com'
      },
      {
        address     => '10.0.1.225/32',
        description => 'blog2-web-virt-sjc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.199/32',
        description => 'blog2-web-virt-ewr3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.119/32',
        description => 'blog3-web-virt-sjc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.214/32',
        description => 'blog3-web-virt-ewr3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.113/32',
        description => 'blog4-web-virt-ewr3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.62/32',
        description => 'blog4-web-virt-sjc3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.9/32',
        description => 'blog5-web-virt-ewr3.mydevopscdn.com'
      },
      {
        address     => '10.0.1.47/32',
        description => 'blog5-web-virt-sjc3.mydevopscdn.com'
      },
    ]
  }

  mydevops_blog::db::permit{"db access to Nadezhda":
    dbuser     => 'reports',
    dbname    => 'mydevops_sasp',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '85.238.102.93/32',
        description => 'db access to Nadezhda 1'
      },
      {
        address     => '185.132.1.27/32',
        description => 'db access to Nadezhda 2'
      },
      {
        address     => '217.20.164.65/32',
        description => 'db access to Nadezhda 4'
      },
      {
        address     => '162.253.159.69/32',
        description => 'db access to Nadezhda 3'
      },

    ]
  }
  mydevops_blog::db::permit{"db access to Oleh Mozhaiev":
    dbuser     => 'olehm',
    dbname    => 'mydevops_sasp',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '162.253.159.147/32',
        description => 'db access to Oleh Mozhaiev vpn'
      },
    ]
  }

mydevops_blog::db::permit{"db access to developers":
    dbuser     => 'developers',
    dbname    => 'mydevops_sasp',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '85.238.102.93/32',
        description => 'db access to developers 1'
      },
      {
        address     => '185.132.1.27/32',
        description => 'db access to developers 2'
      },
      {
        address     => '217.20.164.65/32',
        description => 'db access to developers 3'
      },
    ]
  }  
mydevops_blog::db::permit{"db access to bi_reports'":
    dbuser     => 'bi_reports',
    dbname    => 'mydevops_sasp',
    dbauth   => 'md5',
     allow   => [
      {
        address     => '162.255.24.5/32',
        description => 'db access to bi_reports'
      },
    ]
  } 
  
create_resources(ssh_authorized_key, lookup('mydevops_blog::ssh_keys', {}))
create_resources(cron::job, lookup('mydevops_blog::cron::job', {}))

include mydevops_postfix::smarthost
include mydevops_blog::prod_backup

}
