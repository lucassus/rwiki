require 'singleton'

class Configuration
  include Singleton

  attr_accessor :rwiki_path
  attr_accessor :page_file_extension

  def initialize
    @page_file_extension = 'txt'
  end

end
