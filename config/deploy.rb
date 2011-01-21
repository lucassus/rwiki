set :application, "rwiki"
set :deploy_to, "/home/projects/rwiki"

set :scm, :git
set :repository, "git://github.com/lucassus/rwiki.git"

set :domain, "vps_rwiki"
role :app, domain

namespace :deploy do
  desc "Restart the application"
  task :restart, :role => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_shared, :roles => :app do
    # Symlink configuration
    run "rm -rf #{release_path}/config/config.yml"
    run "ln -s #{shared_path}/config/config.yml #{release_path}/config/config.yml"

    # Symlink notes
    run "rm -rf #{release_path}/notes"
    run "ln -s #{shared_path}/notes #{release_path}/notes"

    # Symlink gems
    run "rm -rf #{release_path}/vendor/bundle"
    run "ln -s #{shared_path}/vendor/bundle #{release_path}/vendor/bundle"
  end

  task :bundle_install, :roles => :app do
    run "cd #{current_path} && bundle install --path vendor/bundle"
  end
end

after :deploy, :'deploy:symlink_shared'
after :deploy, :'deploy:bundle_install'
