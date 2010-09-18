module Rwiki::Models
  class Page < Node

    FILE_EXTENSION = 'txt'

    def initialize(path)
      raise ArgumentError unless File.exist?(path)
      raise ArgumentError unless File.file?(path)
      raise ArgumentError unless path.end_with?(FILE_EXTENSION)

      super(path)
    end

  end
end
