require 'rubygems' if RUBY_VERSION < "1.9"

require 'coderay'
require 'erb'
require 'json/pure'
require 'redcloth'
require 'sinatra'
require 'sinatra/base'
require 'fuzzy_file_finder'
require 'smart_asset'

module Rwiki

  class NodeError < StandardError; end
  class NodeNotFoundError < NodeError; end

  autoload :App, 'rwiki/app'
  autoload :Configuration, 'rwiki/configuration'
  autoload :Node, 'rwiki/node'
  autoload :Utils, 'rwiki/utils'

  def self.debug
    require 'ruby-debug'
    debugger
  end

  def self.configuration
    Configuration.instance
  end

end
