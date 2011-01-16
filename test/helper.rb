$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rwiki'

require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'shoulda'
require File.expand_path(File.join(File.dirname(__FILE__), 'tmpdir_helper'))

ENV['RACK_ENV'] = 'test'

class Test::Unit::TestCase
  include TmpdirHelper

  def setup
    create_tmpdir!
  end

  def teardown
    remove_tmpdir!
  end
end
