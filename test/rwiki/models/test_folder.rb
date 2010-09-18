require File.expand_path(File.dirname(__FILE__) + '../../../helper')

class Rwiki::Models::TestFolder < Test::Unit::TestCase
  include Rwiki::Models

  context 'Page construnctor' do
    context 'with path to non-existing file' do
      setup { @file_name = '/.non-existing' }

      should 'raise an exception' do
        assert_raise ArgumentError do
          Folder.new(@file_name)
        end
      end
    end

    context 'with path to the file' do
      setup { @file_name = './home.txt' }

      should 'raise an exception' do
        assert_raise ArgumentError do
          Folder.new(@file_name)
        end
      end
    end
  end

end
