lock '3.3.5'

set :application, 'jarviis'
set :repo_url, 'git@github.com:Jarviis/Jarviis.git'
# Change this according to your liking for staging environment
set :branch, 'master'

set :unicorn_pid, "/var/www/jarviis/current/tmp/pids/unicorn.pid"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets, public/app, public/assets, public/components}
set :conditionally_migrate, :true
set :bower_flags, '--allow-root --quite --config.interactive=false'
set :bower_roles, :app
set :assets_roles, [:app]

namespace :deploy do
  after  :finishing, "deploy:cleanup"
  after "deploy:publishing", "deploy:restart"

  after "deploy:restart", "unicorn:legacy_restart"
end
