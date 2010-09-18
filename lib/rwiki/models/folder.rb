module Rwiki::Models
  class Folder < Node

    def initialize(path)
      raise ArgumentError unless File.exist?(path)
      raise ArgumentError unless File.directory?(path)

      super(path)
    end

  end
end
