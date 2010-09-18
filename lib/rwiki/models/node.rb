module Rwiki::Models
  class Node

    def self.new_from_path(path)
      raise unless File.exist?(path)
      
      klass = File.directory?(path) ? Folder : Page
      return klass.new(path)
    end

  end
end
