require File.expand_path(File.dirname(__FILE__) + '../../../helper')

class Rwiki::Models::TestPage < Test::Unit::TestCase
  include Rwiki::Models

  context 'Page construnctor' do
    context 'with path to non-existing file' do
      setup { @file_name = '/.non-existing.txt' }

      should 'raise an exception' do
        assert_raise ArgumentError do
          Page.new(@file_name)
        end
      end
    end

    context 'with path to the folder' do
      setup { @file_name = './folder' }

      should 'raise an exception' do
        assert_raise ArgumentError do
          Page.new(@file_name)
        end
      end
    end

    context 'with illegal filename' do
      setup { @file_name = './empty_folder/dummy' }

      should 'raise an exception' do
        assert_raise ArgumentError do
          Page.new(@file_name)
        end
      end
    end
  end

end
