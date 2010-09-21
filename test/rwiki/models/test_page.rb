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

  context 'A page instance' do
    setup { @page = Page.new('./home.txt') }

    context 'raw_content method' do
      should 'return valid raw_content' do
        assert @page.raw_content
        assert_equal 'h1. Sample page', @page.raw_content
      end
    end

    context 'html_content method' do
      should 'return valid html_content' do
        assert @page.html_content
        assert_equal '<h1><a name="Sample+page">Sample page</a></h1>', @page.html_content
      end
    end

    context 'title method' do
      should 'return valid title' do
        assert_equal 'home', @page.title
      end
    end
  end


end
