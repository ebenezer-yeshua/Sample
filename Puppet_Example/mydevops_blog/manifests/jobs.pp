class mydevops_blog::jobs {
  mydevops_supervisor::program{"delayed_job_default":
    command           => "/usr/local/rvm/bin/ruby-rvm-env /home/sites/accounts.mydevops.com/script/delayed_job --queue=default run",
    user              => "sites",
    working_directory => "/home/sites/accounts.mydevops.com",
    environment       => {
      "RAILS_ENV" => "production",
      "GEM_HOME"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5",
      "GEM_PATH"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5:/usr/local/rvm/gems/ruby-2.6.2@global",
    }
  }

  mydevops_supervisor::program{"delayed_job_long":
    command           => "/usr/local/rvm/bin/ruby-rvm-env /home/sites/accounts.mydevops.com/script/delayed_job --queue=long run",
    user              => "sites",
    working_directory => "/home/sites/accounts.mydevops.com",
    environment       => {
      "RAILS_ENV" => "production",
      "GEM_HOME"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5",
      "GEM_PATH"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5:/usr/local/rvm/gems/ruby-2.6.2@global",
    }
  }

  mydevops_supervisor::program{"delayed_job_mailers":
    command           => "/usr/local/rvm/bin/ruby-rvm-env /home/sites/accounts.mydevops.com/script/delayed_job --queue=mailers run",
    user              => "sites",
    working_directory => "/home/sites/accounts.mydevops.com",
    environment       => {
      "RAILS_ENV" => "production",
      "GEM_HOME"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5",
      "GEM_PATH"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5:/usr/local/rvm/gems/ruby-2.6.2@global",
    }
  }

  mydevops_supervisor::program{"delayed_job_vtiger":
    command           => "/usr/local/rvm/bin/ruby-rvm-env /home/sites/accounts.mydevops.com/script/delayed_job --queue=vtiger run",
    user              => "sites",
    working_directory => "/home/sites/accounts.mydevops.com",
    environment       => {
      "RAILS_ENV" => "production",
      "GEM_HOME"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5",
      "GEM_PATH"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5:/usr/local/rvm/gems/ruby-2.6.2@global",
    }
  }

  mydevops_supervisor::program{"delayed_job_get_statistic":
    command           => "/usr/local/rvm/bin/ruby-rvm-env /home/sites/accounts.mydevops.com/script/delayed_job --queue=get_statistic run",
    user              => "sites",
    working_directory => "/home/sites/accounts.mydevops.com",
    environment       => {
      "RAILS_ENV" => "production",
      "GEM_HOME"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5",
      "GEM_PATH"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5:/usr/local/rvm/gems/ruby-2.6.2@global",
    }
  }

  mydevops_supervisor::program{"delayed_job_synctask":
    command           => "/usr/local/rvm/bin/ruby-rvm-env /home/sites/accounts.mydevops.com/script/delayed_job --queue=synctask run",
    user              => "sites",
    working_directory => "/home/sites/accounts.mydevops.com",
    environment       => {
      "RAILS_ENV" => "production",
      "GEM_HOME"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5",
      "GEM_PATH"  => "/usr/local/rvm/gems/ruby-2.6.2@blog5:/usr/local/rvm/gems/ruby-2.6.2@global",
    }
  }
}
