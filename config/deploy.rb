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
    run "ln -s #{shared_path}/config/config.yml #{release_path}/config/config.yml"

    # Symlink notes
    run "rm -rf #{release_path}/notes"
    run "ln -s #{shared_path}/notes #{release_path}/notes"
  end

end
