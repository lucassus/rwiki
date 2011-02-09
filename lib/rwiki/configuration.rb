require 'singleton'

class Configuration
  include Singleton
  attr_accessor :rwiki_path
end
