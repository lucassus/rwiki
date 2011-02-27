$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"

set :rvm_type, :system

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

    # Symlink gems
    run "rm -rf #{release_path}/vendor/bundle"
    run "ln -s #{shared_path}/bundle #{release_path}/vendor/bundle"
  end

  task :bundle_install, :roles => :app do
    run "cd #{current_path} && bundle install --path vendor/bundle"
  end

  task :smart_asset, :roles => :app do
    run "cd #{current_path} && bundle exec smart_asset"
  end
end

after :deploy, :'deploy:symlink_shared'
after :deploy, :'deploy:bundle_install'
after :deploy, :'deploy:smart_asset'
