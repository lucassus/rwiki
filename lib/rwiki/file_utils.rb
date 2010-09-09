module Rwiki
  module FileUtils
    include ::FileUtils

    def make_tree(dir)
      tree_nodes = []

      entries = Dir.entries(dir).sort
      entries.each do |file_name|
        next if file_name.match(/^\./)

        file_name_with_directory = File.join(dir, file_name)
        if File.directory?(file_name_with_directory)
          tree_nodes << { :text => file_name, :cls => 'folder', :id => file_name_with_directory }
        else
          next unless file_name.match(/\.txt$/)
          tree_nodes << { :text => file_name, :cls => 'file', :leaf => true, :id => file_name_with_directory }
        end
      end

      return tree_nodes
    end

    def read_file(file_name)
      return File.read(file_name) { |f| f.read }
    end

    def write_file(file_name, content)
      file = File.open(file_name, 'w')
      file.write(content)
      file.close

      return content
    end

    def create_directory(parent, name)
      mkdir(File.join(parent, name))
    end

    def create_file(parent, name)
      touch(File.join(parent, name) + '.txt')
    end

    def delete_node(name)
      rm_rf(File.join(name))
    end

  end
end
