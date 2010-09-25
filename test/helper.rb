$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rwiki'

require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'shoulda'

ENV['RACK_ENV'] = 'test'

class Test::Unit::TestCase
  TMP_DIR = '/tmp/rwiki_test'

  def tmp_dir
    TMP_DIR
  end

  def create_tmpdir!
    FileUtils.mkdir_p(tmp_dir)
    pages_dir = File.expand_path('../fixtures/pages', __FILE__)
    FileUtils.cp_r(pages_dir, tmp_dir)

    # change working directory to the wiki root
    working_path = File.join(tmp_dir, 'pages')
    Rwiki::Models::Node.working_path = working_path
  end

  def remove_tmpdir!
    FileUtils.rm_rf(tmp_dir)
  end

  def setup
    create_tmpdir!
  end

  def teardown
    remove_tmpdir!
  end

end
