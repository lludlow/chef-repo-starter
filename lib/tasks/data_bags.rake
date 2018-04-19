###
#
# data_bags.rake - Define rake tasks to ensure that data bag files are valid
#                  JSON and use knife to upload them to the Chef server.
#
Chef::Knife::DataBagFromFile.load_deps

namespace :data_bags do
  desc 'Validate data bag files'
  JsonLint::RakeTask.new(:validate) do |t|
    t.paths = data_bag_items('data_bags')
  end

  desc 'Upload data bags from files into the Chef server'
  task :upload => :validate do
    knife = Chef::Knife::DataBagFromFile.new
    knife.config[:verbosity] = 3
    data_bag_dirs('data_bags').each do |bag|
      knife_data_bag = Chef::Knife::DataBagCreate.new
      knife_data_bag.name_args = bag
      knife_data_bag.run

      item_files = Dir.entries("data_bags/#{bag}").select { |f| f.match(/.+\.json/) }
      item_files.each do |item|
        knife.name_args = [bag, item]
        knife.loader.load_from('data_bags', bag, item)
        knife.run
      end
    end
  end
end
