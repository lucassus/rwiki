require 'singleton'

module Rwiki
  class Configuration
    include Singleton

    attr_accessor :rwiki_path
    attr_accessor :page_file_extension

    def initialize
      @rwiki_path = Dir.pwd
      @page_file_extension = 'txt'
    end

  end
end
