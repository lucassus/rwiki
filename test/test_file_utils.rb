require 'helper'

class TestFileUtils < Test::Unit::TestCase

  class Dummy
    include Rwiki::FileUtils
  end

  context 'nodes id encoding' do
    setup do
      @instance = Dummy.new
    end

    
  end

end
