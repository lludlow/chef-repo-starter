###
#
# roles.rake - Define rake tasks to ensure that role files are valid JSON and
# use knife to upload them to the Chef server.
#
Chef::Knife::RoleFromFile.load_deps

roles_files = Dir.entries('roles').select { |f| f.match(/.+\.json/) }

namespace :roles do
  desc 'Validate roles files'
  JsonLint::RakeTask.new(:validate) do |t|
    json_files = roles_files.map { |f| "roles/#{f}" }
    t.paths = json_files
  end

  desc 'Upload roles from files into the Chef server'
  task :upload, [:role] => :validate do |_, args|
    json_files = args[:role].nil? ? roles_files : ["#{args[:role]}.json"]
    knife = Chef::Knife::RoleFromFile.new
    knife.name_args = json_files
    json_files.each do |f|
      knife.loader.load_from('roles', f)
    end
    knife.run
  end
end
