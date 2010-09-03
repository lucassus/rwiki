require 'pp'
require 'activesupport'

# {name, directory, nodes}
def make_tree(base_dir)
  tree = []

  Dir.entries(base_dir).each do |file_name|
    next if ['.', '..'].include?(file_name)

    full_file_name = File.join(base_dir, file_name)
    if File.directory?(full_file_name)
      tree << { :name => file_name, :directory => true, :nodes => make_tree(full_file_name) }
    else
      tree << { :name => file_name, :directory => false }
    end
  end

  return tree
end

base_dir = "/home/lucassus/Downloads"
make_tree(base_dir).to_json
