  #
class mydevops_blog::db_staging_firewall {
  
  mydevops_firewall::permit{"POSTGRES to web1-blog-virt-ewr1.mydevopscdn.com":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to web2-blog-virt-ewr1.mydevopscdn.com":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to blog-staging-virt-ewr1.mydevopscdn.com":
    chain   => "POSTGRES",
    address => "10.165.13.206/24"
  }
  mydevops_firewall::permit{"POSTGRES to blog-staging-virt-ewr1.mydevopscdn.com-public":
    chain   => "POSTGRES",
    address => "10.165.8.174/32"
  }
  mydevops_firewall::permit{"POSTGRES to Apple PC":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to Apple external 1":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to Apple external 2":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to Apple external 3":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to Apple external 4":
    chain   => "POSTGRES",
    address => "62.16.2.88/24"
  }
  mydevops_firewall::permit{"POSTGRES to Apple external 5":
    chain   => "POSTGRES",
    address => "194.28.71.7/24"
  }
  mydevops_firewall::permit{"POSTGRES to Orange Mozhaev":
    chain   => "POSTGRES",
    address => "85.238.107.29/24"
  }
  mydevops_firewall::permit{"POSTGRES to banana Luchina 1":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to banana Luchina 2":
    chain   => "POSTGRES",
    address => "10.100.70.124/24"
  }
  mydevops_firewall::permit{"POSTGRES to Apple Grechko 1":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to ua-reports":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to reports":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to banana Apple Grechko 2":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to metadb1-virt-ewr1.mydevopscdn.com":
    chain   => "POSTGRES",
    address => "10.165.10.22/24"
  }
  mydevops_firewall::permit{"POSTGRES to bi_reports":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
  mydevops_firewall::permit{"POSTGRES to bi_reports":
    chain   => "POSTGRES",
    address => "10.165.8.174/24"
  }
}
