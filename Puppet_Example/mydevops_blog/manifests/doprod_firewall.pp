class mydevops_blog::doprod_firewall {

 mydevops_firewall::service{'blog-doprod-firewall':
    ports            => [80,443],
    allow_admins     => true,
    allow_monitoring => true
  }

mydevops_firewall::permit{'blog-doprod 10.0.1.85':
    	chain   => 'blog-doprod-firewall',
    	address => '157.51.16.85'
  	}
mydevops_firewall::permit{'blog-doprod 3.10.0.1.247':
    	chain   => 'blog-doprod-firewall',
    	address => '3.210.113.247'
  	}
}
