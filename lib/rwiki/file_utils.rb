require 'redcloth'

module Rwiki
  module FileUtils
    def make_tree(base_dir)
      tree = []

      Dir.entries(base_dir).each do |file_name|
        next if file_name.match(/^\./)

        full_file_name = File.join(base_dir, file_name)
        if File.directory?(full_file_name)
          tree << { :text => file_name, :cls => 'folder', :id => full_file_name }
        else
          tree << { :text => file_name, :cls => 'file', :leaf => true, :id => full_file_name }
        end
      end

      return tree
    end

    def read_file(file_name)
      raw = File.read(file_name) { |f| f.read }
      html = RedCloth.new(raw).to_html

      return {:raw => raw, :html => html}
    end
  end
end
