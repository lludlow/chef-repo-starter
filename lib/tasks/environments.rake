###
#
# environments.rake - Define rake tasks to ensure that environment files are
#                     valid JSON and use knife to upload them to the Chef server.
#
Chef::Knife::EnvironmentFromFile.load_deps

env_files = Dir.entries('environments').select { |f| f.match(/.+\.json/) }

namespace :environments do
  desc 'Validate environment files'
  JsonLint::RakeTask.new(:validate) do |t|
    json_files = env_files.map { |f| "environments/#{f}" }
    t.paths = json_files
  end

  desc 'Upload environment from files into the Chef server'
  task :upload, [:environment] => :validate do |_, args|
    json_files = env_files
    json_files = ["#{args[:environment]}.json"] unless args[:environment].nil?
    knife = Chef::Knife::EnvironmentFromFile.new
    knife.name_args = json_files
    json_files.each do |f|
      knife.loader.load_from('environments', f)
    end
    knife.run
  end
end
