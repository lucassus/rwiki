require File.expand_path(File.dirname(__FILE__) + '../../../helper')

class Rwiki::Models::TestPage < Test::Unit::TestCase
  include Rwiki::Models

  context 'Page construnctor' do
    context 'with path to non-existing file' do
      setup { @file_name = '/.non-existing.txt' }

      should 'raise PageNotFountError' do
        exception = assert_raise Rwiki::NodeNotFoundError do
          Page.new(@file_name)
        end

        assert_equal "cannot find #{@file_name}", exception.message
      end
    end

    context 'with path to the folder' do
      setup { @file_name = './folder' }

      should 'raise PageNotFountError' do
        exception = assert_raise Rwiki::NodeNotFoundError do
          Page.new(@file_name)
        end

        assert_equal "cannot find #{@file_name}", exception.message
      end
    end

    context 'with illegal filename' do
      setup { @file_name = './empty_folder/dummy' }

      should 'raise PageNotFountError' do
        exception = assert_raise Rwiki::NodeNotFoundError do
          Page.new(@file_name)
        end

        assert_equal "#{@file_name} has illegal name", exception.message
      end
    end
  end

  context 'A page instance' do
    setup { @page = Page.new('./home.txt') }

    context ':raw_content method' do
      should 'return valid raw_content' do
        assert @page.raw_content
        assert_equal 'h1. Sample page', @page.raw_content
      end
    end

    context ':html_content method' do
      should 'return valid html_content' do
        assert @page.html_content
        # TODO extend this test
      end
    end

    context ':title method' do
      should 'return valid title' do
        assert_equal 'home', @page.title
      end
    end

    context ':rename method' do
      context 'for existing page' do
        setup { @new_name = 'test.txt' }

        should 'raise an exception' do
          exception = assert_raise Rwiki::NodeError do
            @page.rename(@new_name)
          end

          assert_equal "./test.txt already exists", exception.message
        end
      end

      context 'for non-existing page' do
        setup do
          @content_before_rename = @page.raw_content
          @new_name = 'gierrary_hirr'
          
          assert_nothing_raised do
            @page.rename(@new_name)
          end
        end

        should 'rename file' do
          old_full_path = File.join(@page.parent_folder.full_path, 'home.txt')
          assert !File.exist?(old_full_path), "#{old_full_path} is still exists"

          new_full_path = File.join(@page.parent_folder.full_path, 'gierrary_hirr.txt')
          assert File.exist?(new_full_path), "#{new_full_path} is not exist"
        end

        should 'not change the page content' do
          @page.reload!
          assert_equal @content_before_rename, @page.raw_content
        end

        should 'set valid path and title' do
          assert_equal "./gierrary_hirr.txt", @page.path
          assert_equal "gierrary_hirr", @page.title
        end
      end
    end
  end
end
