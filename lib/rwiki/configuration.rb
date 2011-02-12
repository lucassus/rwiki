require 'singleton'

module Rwiki
  class Configuration
    include Singleton

    attr_accessor :rwiki_path
    attr_accessor :root_page_name
    attr_accessor :page_file_extension

    def initialize
      @rwiki_path = Dir.pwd
      @root_page_name = 'Home'
      @page_file_extension = 'txt'
    end

  end
end
