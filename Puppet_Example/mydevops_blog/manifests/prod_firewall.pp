class mydevops_blog::prod_firewall {

 /*mydevops_firewall::service{'blog-prod-firewall':
    ports            => [80,443],
    allow_admins     => true,
    allow_monitoring => true
  }

mydevops_firewall::permit{'blog-prod 10.0.1.228':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.228'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.247':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.247'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.212':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.212'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.128':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.128'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.109':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.109'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.208':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.208'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.200':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.200'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.226':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.226'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.146':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.146'
  	}
mydevops_firewall::permit{'blog-prod 18.194.133.144':
    	chain   => 'blog-prod-firewall',
    	address => '18.194.133.144'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.213':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.213'
  	}
mydevops_firewall::permit{'blog-prod 10.0.131':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.31'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.170':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.170'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.186':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.186'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.126':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.126'
  	}
mydevops_firewall::permit{'blog-prod 18.195.132.170':
    	chain   => 'blog-prod-firewall',
    	address => '18.195.132.170'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.89':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.89'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.194':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.194'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.242':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.242'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1168':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.168'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.105':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.105'
  	}
mydevops_firewall::permit{'blog-prod 18.197.154.55':
    	chain   => 'blog-prod-firewall',
    	address => '18.197.154.55'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.130':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.130'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.111':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.111'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.130':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.130'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.99':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.99'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.94':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.94'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.5':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.5'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.0':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.0'
  	}
mydevops_firewall::permit{'blog-prod10.0.1.16':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.16'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.128':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.128'
  	}
mydevops_firewall::permit{'blog-prod 10.0.1.176':
    	chain   => 'blog-prod-firewall',
    	address => '10.0.1.176'
  	}
}
