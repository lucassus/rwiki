require File.join(File.dirname(__FILE__), '..', '..', 'lib/rwiki')

require 'rspec'
require 'cucumber/web/tableish'
require 'capybara'
require 'capybara/cucumber'
require File.expand_path(File.join(File.dirname(__FILE__), '../../test/tmpdir_helper'))

Rwiki::App.set(:environment, :test)

# Selenium setup
require 'selenium/webdriver'
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  # profile.add_extension File.expand_path(File.join(File.dirname(__FILE__), 'firebug-1.6.1-fx.xpi'))
  Capybara::Driver::Selenium.new(app, :profile => profile)
end
Capybara.default_driver = :selenium

World do
  Capybara.app = Rwiki::App

  include RSpec::Expectations
  include RSpec::Matchers

  include TmpdirHelper

  AfterStep do
    Given %Q{I wait for load the tree}
    And %Q{I wait for an ajax call complete}
  end

  Before do
    create_tmpdir!
  end

  After do
    remove_tmpdir!
  end
end
