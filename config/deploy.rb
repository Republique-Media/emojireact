require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/unicorn'
require 'securerandom'

# app             - The directory and database name
# repository      - Git repo to clone from
# branch          - Branch name to deploy
# domain          - The hostname to SSH to
# user            - The username to SSH to
# deploy_to       - Path to deploy into
# port            - SSH port number
# forward_agent   - SSH forward_agent

set :term_mode, :system

set :application, "emoji_react"
set :repository, "git@gitlab.voupe.uk:voupe/emoji-react.git"
set :branch, "master"

set :domain, "163.172.220.87"
set :port, 2222
set :user, "deploy"
set :deploy_to, "/opt/apps/#{application}"

set :whenever_name, "#{application}_production"

set :shared_path_full, "#{deploy_to}/#{shared_path}"

# Manually create these paths in shared/ in your server.
# eg: shared/config/database.yml
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, [
  "log",
  "tmp/sockets",
  "tmp/pids",
  "config/database.yml",
  "config/secrets.yml"
]


task :setup do
  queue! %[mkdir -p "#{shared_path_full}/log"]
  queue! %[mkdir -p "#{shared_path_full}/tmp/sockets"]
  queue! %[mkdir -p "#{shared_path_full}/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{shared_path_full}/log"]
  queue! %[chmod g+rx,u+rwx "#{shared_path_full}/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{shared_path_full}/tmp/pids"]

  queue! %[mkdir -p "#{shared_path_full}/config/initializers"]

  # Add the repository server to .ssh/known_hosts
  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    queue! %[
      if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end

  # Create blank files for each of the shared_paths
  shared_paths.each do |sp|
    queue! %[ touch "#{shared_path_full}/#{sp}" ]
  end

  # Fill in database.yml if the file is empty
  path_database_yml = "#{shared_path_full}/config/database.yml"
  database_yml = %[production:
  database: #{application}_production
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: #{application}
  password: #{SecureRandom.hex(8)}
  host: localhost]
  queue! %[ test -s #{path_database_yml} || echo "#{database_yml}" > #{path_database_yml} ]

  # Fill in secrets.yml if the file is empty
  path_secrets_yml = "#{shared_path_full}/config/secrets.yml"
  secrets_yml = %[production:
  secret_key_base: #{`rake secret`.strip}]
  queue! %[ test -s #{path_secrets_yml} || echo "#{secrets_yml}" > #{path_secrets_yml} ]

  queue! %[ chmod g+rx,u+rwx,o-rwx "#{shared_path_full}/config" ]

end

desc "Deploys the current version to the server."
task :deploy do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke "git:clone"
    invoke "deploy:link_shared_paths"
    invoke "bundle:install"
    invoke "rails:db_migrate"
    invoke "rails:assets_precompile"
    invoke "deploy:cleanup"

    to :launch do
      invoke "unicorn:restart"
    end
  end
end

desc "Tails the log files"
task :logs do
  queue %[tail -f #{shared_path_full}/log/*.log]
end

task :console do
  queue! "#{rails} console"
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
