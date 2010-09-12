module Rwiki
  module FileUtils
    include ::FileUtils

    def make_tree(folder_name)
      make_nodes(folder_name)
    end

    def make_nodes(folder_name)
      tree_nodes = []

      entries = Dir.entries(folder_name).sort
      entries.each do |node_base_name|
        next if node_base_name.match(/^\./)

        node_name = File.join(folder_name, node_base_name)
        tree_node = { :text => node_base_name, :id => node_name }

        if File.directory?(node_name)
          children = make_nodes(node_name)
          tree_nodes << tree_node.merge(:cls => 'folder', :children => children)
        else
          next unless node_base_name.match(/\.txt$/)
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
    end

    def create_folder(parent_folder_name, base_name)
      new_folder_name = File.join(parent_folder_name, base_name)
      mkdir(new_folder_name)

      return new_folder_name
    end

    def create_page(parent_folder_name, base_name)
      new_page_name = File.join(parent_folder_name, base_name) + '.txt'
      touch(new_page_name)

      return new_page_name
    end

    def rename_node(old_node_name, new_base_name)
      new_name = File.join(File.dirname(old_node_name), new_base_name)
      
      return false if File.exists?(new_name)
      mv(old_node_name, new_name)

      return true, new_name
    end

    def move_node(node_name, dest_folder_name)
      new_node_name = File.join(dest_folder_name, File.basename(node_name))
      return false if File.exists?(new_node_name)
      
      mv(node_name, dest_folder_name)
      return true, new_node_name
    end

    def delete_node(node_name)
      rm_rf(File.join(node_name))
    end

  end
end
