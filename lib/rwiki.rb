require 'rubygems' if RUBY_VERSION < "1.9"

require 'coderay'
require 'erb'
require 'json/pure'
require 'redcloth'
require 'sinatra'
require 'sinatra/base'

module Rwiki

  class FolderError < StandardError; end
  class FolderNotFoundError < FolderError; end
  class PageError < StandardError; end
  class PageNotFoundError < PageError; end

  autoload :App, 'rwiki/app'
  autoload :Models, 'rwiki/models'
  autoload :Utils, 'rwiki/utils'

  def self.debug
    require 'ruby-debug'
    debugger
  end
  
end
