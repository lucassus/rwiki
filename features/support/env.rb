require File.join(File.dirname(__FILE__), '..', '..', 'lib/rwiki')

require 'rspec'
require 'cucumber/web/tableish'
require 'capybara'
require 'capybara/cucumber'

# Selenium setup
require 'selenium/webdriver'
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  load_firebug_extension = false
  profile.add_extension File.expand_path(File.join(File.dirname(__FILE__), 'firebug-1.6.1-fx.xpi')) if load_firebug_extension
  Capybara::Driver::Selenium.new(app, :profile => profile)
end
Capybara.default_driver = :selenium

World do
  Rwiki::App.set(:environment, :test)
  Rwiki::App.set(:logging, false) # do not output logs on the STDOUT

  Capybara.app = Rwiki::App

  include RSpec::Expectations
  include RSpec::Matchers

  require File.expand_path(File.join(File.dirname(__FILE__), '../../spec/tmpdir_helper'))
  include TmpdirHelper

  AfterStep do
    Given %Q{I wait for load the tree}
    And %Q{I wait for an ajax call complete}
  end

  Before do
    create_tmpdir!
  end

  After do |scenario|
    remove_tmpdir!

    if scenario.failed?
      screenshots_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'reports', 'screenshots'))
      FileUtils.mkdir_p(screenshots_dir) unless Dir.exists?(screenshots_dir)

      feature_file = if scenario.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)
        scenario.scenario_outline.feature.file
       else
        scenario.feature.file
       end

      file_name = "#{feature_file.split('/').last}:#{scenario.line}.png"
      page.driver.browser.save_screenshot(File.join(screenshots_dir, file_name))
    end
  end
end
