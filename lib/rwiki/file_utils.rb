module Rwiki
  module FileUtils
    include ::FileUtils

    PAGE_FILE_EXT = '.txt'

    def make_tree(folder_name)
      make_nodes(folder_name)
    end

    def make_nodes(folder_name)
      tree_nodes = []

      nodes = Dir.entries(folder_name).sort
      nodes.each do |node_base_name|
        next if node_base_name.match(/^\./) # skip hidden files

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

    def read_page(page_name)
      return nil unless File.exists?(page_name)
      return File.read(page_name) { |f| f.read } rescue nil
    end

    def write_page(page_name, content)
      return false unless File.exists?(page_name)
      
      file = File.open(page_name, 'w')
      file.write(content)
      file.close

      return true
    rescue e
      return false
    end

    def create_folder(parent_folder_name, folder_base_name)
      folder_name = File.join(parent_folder_name, folder_base_name)
      return false if File.exists?(folder_name)
      mkdir(folder_name)

      return folder_name
    end

    def create_page(parent_folder_name, page_base_name)
      page_name = File.join(parent_folder_name, page_base_name)
      return false if File.exists?(page_name)
      touch(page_name)

      return page_name
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
      return false unless File.exists?(node_name)
      rm_rf(File.join(node_name))
      return true
    end

  end
end
