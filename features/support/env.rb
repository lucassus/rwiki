require File.join(File.dirname(__FILE__), '..', '..', 'lib/rwiki')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Rwiki::App.set(:environment, :test)

World do
  Capybara.app = Rwiki::App

  include RSpec::Expectations
  include RSpec::Matchers
end
