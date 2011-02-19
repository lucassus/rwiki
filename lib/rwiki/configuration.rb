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

    def root_page_path
      '/' + root_page_name
    end

    def root_page_full_path
      File.join(rwiki_path, root_page_path)
    end

    def root_page_full_file_path
      root_page_full_path + '.' + page_file_extension
    end

  end
end
