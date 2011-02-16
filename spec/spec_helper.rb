$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rwiki'
require 'ap'
require 'rack/test'

require 'tmpdir_helper'
require 'rwiki_macros'

RSpec.configure do |config|

  config.include(TmpdirHelper)
  config.include(RwikiMacros)  

  # == Mock Framework
  config.mock_with :mocha

  config.before(:each) do
    create_tmpdir!
  end

end
