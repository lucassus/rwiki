$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rwiki'
require 'ap'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test', 'tmpdir_helper'))
include TmpdirHelper

RSpec.configure do |config|

  # == Mock Framework
  config.mock_with :mocha

  config.before(:each) do
    create_tmpdir!
  end

  config.after(:each) do
    remove_tmpdir!
  end

end
