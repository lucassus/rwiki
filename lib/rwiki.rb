require 'redcloth'
require 'coderay'
require 'json/pure'
require 'fuzzy_file_finder'
require 'find'

require 'sinatra'
require 'sinatra/base'
require 'erb'
require 'smart_asset'

module Rwiki

  class NodeError < StandardError; end
  class NodeNotFoundError < NodeError; end

  autoload :App, 'rwiki/app'
  autoload :Configuration, 'rwiki/configuration'
  autoload :Page, 'rwiki/page'
  autoload :Rake, 'rwiki/rake'
  autoload :Utils, 'rwiki/utils'

  def self.debug
    require 'ruby-debug'
    debugger
  end

  def self.configuration
    Configuration.instance
  end

end
