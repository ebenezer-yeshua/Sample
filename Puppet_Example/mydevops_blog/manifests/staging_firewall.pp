#
class mydevops_blog::staging_firewall {

  mydevops_firewall::service{'blog-staging-firewall':
    ports            => [80,443],
    allow_admins     => true,
    allow_monitoring => true
  }

  mydevops_firewall::permit{'blog-staging 10.0.1.228':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.228'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.247':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.247'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.212':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.212'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.128':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.128'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.109':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.109'
  }
  mydevops_firewall::permit{'blog-staging 13.58.31.208':
    chain   => 'blog-staging-firewall',
    address => '13.58.31.208'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.200':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.200'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.123':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.123'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.226':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.226'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.146':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.146'
  }
  mydevops_firewall::permit{'blog-staging 10.0.1.144':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.144'
  }
  mydevops_firewall::permit{'blog-staging10.0.1.213':
    chain   => 'blog-staging-firewall',
    address => '10.0.1.213'
  }
}
