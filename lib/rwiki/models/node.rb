module Rwiki::Models
  class Node

    def self.new_from_path(path)
      klass = File.directory?(path) ? Folder : Page
      return klass.new(path)
    end

    def base_name
      File.basename(@path)
    end

    private

    def initialize(path)
      @path = path
    end

  end
end
