require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rwiki'

TMP_DIR = '/tmp/rwiki_test'

class Test::Unit::TestCase

  def tmp_dir
    TMP_DIR
  end

  def create_tmpdir!
    FileUtils.mkdir_p(tmp_dir)
    pages_dir = File.expand_path('../fixtures/pages', __FILE__)
    FileUtils.cp_r(pages_dir, tmp_dir)
    Dir.chdir(File.join(tmp_dir, 'pages'))
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
