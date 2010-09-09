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
          id = encode_directory_name(file_name_with_directory)
          tree_nodes << { :text => file_name, :cls => 'folder', :id => id }
        else
          next unless file_name.match(/\.txt$/)
          
          id = encode_file_name(file_name_with_directory)
          tree_nodes << { :text => file_name, :cls => 'file', :leaf => true, :id => id }
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

    def encode_directory_name(dir)
      'dir-' + dir.gsub('/', '-')
    end

    def encode_file_name(file_name)
      'file-' + file_name.gsub('/', '-').gsub(/\.txt$/, '')
    end

    def decode_node_name(id)
      if id.start_with?('dir-')
        return decode_directory_name(id)
      else
        return decode_file_name(id)
      end
    end

    def decode_directory_name(id)
      id.gsub(/^dir-/, '').gsub('-', '/')
    end

    def decode_file_name(id)
      id.gsub(/^file-/, '').gsub('-', '/') + '.txt'
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
