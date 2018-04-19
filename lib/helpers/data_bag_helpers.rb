###
#
# data_bag_helpers.rb - Helper methods for working with data bags files
#

def data_bag_dirs(dir)
  Dir.entries(dir).select do |d|
    d if File.directory?("#{dir}/#{d}") && !%w[. ..].include?(d)
  end
end

def data_bag_items(dir)
  item_files = []
  data_bag_dirs(dir).each do |d|
    Dir.entries("#{dir}/#{d}").select { |f| f.match(/.+\.json/) }.each do |f|
      item_files << "#{dir}/#{d}/#{f}"
    end
  end
  item_files
end
