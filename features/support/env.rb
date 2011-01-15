require File.join(File.dirname(__FILE__), '..', '..', 'lib/rwiki')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Rwiki::App.set(:environment, :test)

TMP_DIR = '/tmp/rwiki_test'

def tmp_dir
  TMP_DIR
end

def create_tmpdir!
  FileUtils.mkdir_p(tmp_dir)
  pages_dir = File.expand_path(File.join(File.dirname(__FILE__), '../../test/fixtures', 'pages'), __FILE__)
  FileUtils.cp_r(pages_dir, tmp_dir)

  # change working directory to the wiki root
  @working_path = File.join(tmp_dir, 'pages')
  Rwiki::Models::Node.working_path = @working_path
end

def remove_tmpdir!
  FileUtils.rm_rf(tmp_dir)
end

World do
  Capybara.app = Rwiki::App

  include RSpec::Expectations
  include RSpec::Matchers

  Before do
    create_tmpdir!
  end

  After do
    remove_tmpdir!
  end
end
