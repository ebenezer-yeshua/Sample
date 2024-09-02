class mydevops_blog::doprod {
  mydevops_firewall::permit{'ssh permit db1-blog-prod-virt-nyc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.4'
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
  mydevops_firewall::permit{'ssh permit blog1-web-virt-ewr1.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.11'
  }
  mydevops_firewall::permit{'ssh permit blog1-web-virt-sjc1.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.82'
  }
  mydevops_firewall::permit{'ssh permit blog3-web-virt-ewr3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.214'
  }
  mydevops_firewall::permit{'ssh permit blog3-web-virt-sjc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.119'
  }
  mydevops_firewall::permit{'ssh permit blog2-web-virt-sjc3.mydevopscdn.com':
    chain   => ssh,
    address => '10.0.1.225'
  }
  
  mydevops_blog::deploy{'sites':
    site        => 'accounts.mydevops.com',
    ip          => '10.0.1.157',
    staging     => false,
    servers     => [
      {
        name    => 'blog2-web-virt-ewr3.mydevopscdn.com',
        address => '10.0.1.199',
      },
      {
        name    => 'blog2-web-virt-sjc3.mydevopscdn.com',
        address => '10.0.1.225',
      },
      {
        name    => 'blog3-web-virt-ewr3.mydevopscdn.com',
        address => '10.0.1.214',
      },
      {
        name    => 'blog3-web-virt-sjc3.mydevopscdn.com',
        address => '10.0.1.119',
      }
    ],
    deploy_keys => [
      {
        name => 'gitlab-ci',
        type => 'ssh-rsa',
        key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC1/TBCNmuYL6uY0eJg6REQaV6ZyL+glWXS99vrIN2OyghNaG6i/QD0AiEhEZd0Pmae2/SnfOGQYYU4OkMu/yahAQ/Ie/axZfikFNiOy2v5dl1n3RrzTRa+ZAju9iLFMvd57/ZJ07ADsuc7zxBSlPRYYYNAxdONHalqEG0/8QNZD6xFXJjCLpzkRYFcVPtbSuIyJAIvuerQ3jEp+wVRpIge70zCHgl2bNj+ULcHnUcWspvl60sv7DnI5acLDLQH5DVOipFr0cs/9WWHv+n3LI0Vv8LV817guowGcs4yqO/O3/bMmj+L22a52D1p2nk1XTFR78ZemQFOjkGgiq3Pi2aD'
      }
    ],
  }
  
  mydevops_core::host{'accounts.mydevops.com':
    target => $ipaddress, 
  }

  create_resources(ssh_authorized_key, lookup('mydevops_blog::ssh_keys', {}))
  #create_resources(cron::job, lookup('mydevops_blog::cron::job', {}))

  include mydevops_blog::doprod_web
  include mydevops_blog::doprod_ruby
  include mydevops_redis
  include mydevops_blog::pgbouncer
  include mydevops_blog::jobs
  include mydevops_postfix::smarthost
}
