require File.join(File.dirname(__FILE__), '..', '..', 'lib/rwiki')

require 'rspec'
require 'cucumber/web/tableish'
require 'capybara'
require 'capybara/cucumber'
require 'capybara-webkit'

Capybara.javascript_driver = :webkit

World do
  Rwiki::App.set(:environment, :test)
  Rwiki::App.set(:logging, false) # do not output logs on the STDOUT

  Capybara.app = Rwiki::App

  include RSpec::Expectations
  include RSpec::Matchers

  require File.expand_path(File.join(File.dirname(__FILE__), '../../spec/support/tmpdir_helper'))
  include TmpdirHelper

  Before do
    create_tmpdir!
  end

  After do |scenario|
    if scenario.failed?
      screenshots_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'reports', 'screenshots'))
      FileUtils.mkdir_p(screenshots_dir) unless Dir.exists?(screenshots_dir)

      feature_file = if scenario.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)
        scenario.scenario_outline.feature.file
       else
        scenario.feature.file
       end

      file_name = "#{feature_file.split('/').last}-#{scenario.line}.png"
      page.driver.browser.save_screenshot(File.join(screenshots_dir, file_name))
    end
  end
end
