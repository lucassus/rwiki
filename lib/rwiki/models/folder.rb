module Rwiki::Models
  class Folder < Node

    def initialize(path)
      raise ArgumentError unless File.exist?(path)
      raise ArgumentError unless File.directory?(path)

      @path = path
    end

  end
end
