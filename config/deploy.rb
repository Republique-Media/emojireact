require 'mina/rails'
require 'mina/git'
require 'securerandom'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'emojireact'
set :domain, 'server.voupe.com'
set :deploy_to, '/opt/emojireact'
set :repository, 'git@gitlab.voupe.com:voupe/emoji-react.git'
set :branch, 'master'

# Optional settings:
set :user, 'emojireact'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
set :forward_agent, true     # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# set :shared_dirs, fetch(:shared_dirs, []).push('somedir')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # Fill in database.yml if the file is empty
  path_database_yml = "#{fetch(:shared_path)}/config/database.yml"
  database_yml = %[production:
  database: #{fetch(:application_name)}_production
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: #{fetch(:application_name)}
  password: #{SecureRandom.hex(8)}
  host: localhost]
  command %[ test -s #{path_database_yml} || echo "#{database_yml}" > #{path_database_yml} ]

  # Fill in secrets.yml if the file is empty
  path_secrets_yml = "#{fetch(:shared_path)}/config/secrets.yml"
  secrets_yml = %[production:
  secret_key_base: #{`rake secret`.strip}]
  command %[ test -s #{path_secrets_yml} || echo "#{secrets_yml}" > #{path_secrets_yml} ]
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
