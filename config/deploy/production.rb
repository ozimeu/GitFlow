# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

set :stage, :production
set :branch, ENV.fetch('REVISION', 'master')
set :domain, 'production.ozim.eu' # required for automatic app restarts

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
#set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

set :deploy_to, '/home/ozim/domains/production.ozim.eu'

# MyDevil.net custom operations
namespace :deploy do
  # link app to location required by mydevil.net
  after :published, :symlink_to_public_ruby do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "rm -r #{fetch(:deploy_to)}/public_ruby"
      execute "ln -s #{fetch(:release_path)} #{fetch(:deploy_to)}/public_ruby"
    end
  end
  # automatically restart app after deploy
  # after :published, :restart_app do
  #   on roles(:app), in: :groups, limit: 3, wait: 10 do
  #     execute "cd #{release_path} devil www restart #{fetch(:domain)}"
  #   end
  # end
end

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}


server ENV["DEPLOY_SERVER"],
  user: ENV["DEPLOY_USER"],
  roles: %w{web app},
  ssh_options: {
    keys: %w(/Users/lukaszozimek/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey)
  }
