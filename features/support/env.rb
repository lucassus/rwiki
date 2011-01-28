require File.join(File.dirname(__FILE__), '..', '..', 'lib/rwiki')

require 'rspec'
require 'cucumber/web/tableish'
require 'capybara'
require 'capybara/cucumber'
require File.expand_path(File.join(File.dirname(__FILE__), '../../test/tmpdir_helper'))

Rwiki::App.set(:environment, :test)

Capybara.default_selector = :css

require 'selenium/webdriver'
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  Capybara::Driver::Selenium.new(app, :profile => profile)
end

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
