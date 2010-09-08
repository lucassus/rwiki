require 'coderay'
require 'redcloth'

module Rwiki
  module FileUtils

    def make_tree(directory)
      tree = []

      path = File.join(ROOT_PATH, directory)
      entries = Dir.entries(path).sort
      entries.each do |file_name|
        next if file_name.match(/^\./)

        file_name_with_directory = File.join(directory, file_name)
        if File.directory?(File.join(ROOT_PATH, file_name_with_directory))
          id = encode_directory_name(file_name_with_directory)
          tree << { :text => file_name, :cls => 'folder', :id => id }
        else
          id = encode_file_name(file_name_with_directory)
          tree << { :text => file_name, :cls => 'file', :leaf => true, :id => id }
        end
      end

      return tree
    end

    def parse_content(raw)
      raw_after_coderay = coderay(raw)
      html = RedCloth.new(raw_after_coderay).to_html
      
      return { :raw => raw, :html => html }
    end

    def read_file(file_name)
      raw = File.read(File.join(ROOT_PATH, file_name)) { |f| f.read }
      return parse_content(raw)
    end

    def write_file(file_name, content)
      file = File.open(File.join(ROOT_PATH, file_name), 'w')
      file.write(content)
      file.close

      return parse_content(content)
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

    def coderay(text)
      text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
        "<notextile>#{CodeRay.scan($3, $2).div(:css => :class)}</notextile>"
      end
    end

    def create_directory(parent, name)
      ::FileUtils.mkdir(File.join(ROOT_PATH, parent, name))
    end

    def create_file(parent, name)
      ::FileUtils.touch(File.join(ROOT_PATH, parent, name) + '.txt')
    end

    def delete_node(name)
      ::FileUtils.rm_rf(File.join(ROOT_PATH, name))
    end

  end
end
