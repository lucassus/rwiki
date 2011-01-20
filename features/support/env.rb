require File.join(File.dirname(__FILE__), '..', '..', 'lib/rwiki')

require 'rspec'
require 'cucumber/web/tableish'
require 'capybara'
require 'capybara/cucumber'
require File.expand_path(File.join(File.dirname(__FILE__), '../../test/tmpdir_helper'))

Rwiki::App.set(:environment, :test)

Capybara.default_selector = :css
Capybara.register_driver :selenium do |app|
  Capybara::Driver::Selenium
  profile = Selenium::WebDriver::Firefox::Profile.new
#  profile.add_extension(File.expand_path("features/support/firebug-1.6.1-fx.xpi"))

  Capybara::Driver::Selenium.new(app, { :browser => :firefox, :profile => profile })
end

World do
  Capybara.app = Rwiki::App

  include RSpec::Expectations
  include RSpec::Matchers

  include TmpdirHelper

  Before do
    create_tmpdir!
  end

  After do
    remove_tmpdir!
  end
end
