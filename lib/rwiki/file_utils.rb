module Rwiki
  module FileUtils
    include ::FileUtils

    def make_tree(dir)
      tree_nodes = []

      entries = Dir.entries(dir).sort
      entries.each do |file_name|
        next if file_name.match(/^\./)

        full_file_name = File.join(dir, file_name)
        tree_node = { :text => file_name, :id => full_file_name }

        if File.directory?(full_file_name)
          tree_nodes << tree_node.merge(:cls => 'folder')
        else
          next unless file_name.match(/\.txt$/)
          tree_nodes << tree_node.merge(:cls => 'page', :leaf => true)
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

    def create_page(parent, name)
      touch(File.join(parent, name) + '.txt')
    end

    def rename_node(node, new_name)
      mv(node, new_name)
    end

    def move_node(file_name, dir)
      mv(file_name, dir)
    end

    def delete_node(name)
      rm_rf(File.join(name))
    end

  end
end
