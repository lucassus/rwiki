require 'redcloth'

module Rwiki
  module FileUtils

    def make_tree(directory)
      tree = []

      path = File.join(ROOT_PATH, directory)
      Dir.entries(path).each do |file_name|
        next if file_name.match(/^\./)

        file_name_with_directory = File.join(directory, file_name)
        id = encode_file_name(file_name_with_directory)
        if File.directory?(File.join(ROOT_PATH, file_name_with_directory))
          tree << { :text => file_name, :cls => 'folder', :id => "#{id}-dir" }
        else
          tree << { :text => file_name, :cls => 'file', :leaf => true, :id => id }
        end
      end

      return tree
    end

    def parse_content(raw)
      html = RedCloth.new(raw).to_html
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

    def encode_file_name(file_name)
      file_name.gsub('/', '-').gsub('.txt', '')
    end

    def decode_directory_name(id)
      
    end

    def decode_file_name(id)
      id.gsub('-', '/') + '.txt'
    end

  end
end
