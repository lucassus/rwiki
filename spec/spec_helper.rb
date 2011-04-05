$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rwiki'
require 'ap'
require 'rack/test'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("support/**/*.rb", File.dirname(__FILE__))].each do |file|
  require file
end

Rwiki::App.set :environment, :test

RSpec.configure do |config|
  config.include(TmpdirHelper)
  config.include(RwikiMacros)  

  # == Mock Framework
  config.mock_with :mocha

  config.before do
    create_tmpdir!
  end

  config.after do
    remove_tmpdir!
  end
end
