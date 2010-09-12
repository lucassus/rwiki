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

    def create_directory(parent_directory_name, base_name)
      directory_name = File.join(parent_directory_name, base_name)
      mkdir(directory_name)

      return directory_name
    end

    def create_page(oarent_directory_name, base_name)
      file_name = File.join(oarent_directory_name, base_name) + '.txt'
      touch(file_name)

      return file_name
    end

    def rename_node(old_file_name, new_base_name)
      new_full_name = File.join(File.dirname(old_file_name), new_base_name)
      mv(old_file_name, new_full_name)

      return new_full_name
    end

    def move_node(file_name, dest_dir_name)
      mv(file_name, dest_dir_name)
    end

    def delete_node(name)
      rm_rf(File.join(name))
    end

  end
end
