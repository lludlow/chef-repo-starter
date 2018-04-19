###
#
# Rakefile - Automate uploading chef environments / roles / data bags with knife
#

require 'chef/knife'
require 'jsonlint/rake_task'

current_dir = File.dirname(File.expand_path(__FILE__))
Dir[File.join(current_dir, 'lib/helpers/*.rb')].each { |f| require f }

Rake.add_rakelib "#{current_dir}/lib/tasks"

Chef::Knife.load_commands
knife_config = ENV['CHEF_CLIENT_CONFIG'] || File.expand_path('~/.chef/knife.rb')
Chef::Config.from_file(knife_config)

task default: %w[environments:upload
                 roles:upload
                 data_bags:upload]
