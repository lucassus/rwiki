require File.expand_path(File.dirname(__FILE__) + '../../../helper')

class Rwiki::Models::TestFolder < Test::Unit::TestCase
  include Rwiki::Models

  context 'Page construnctor' do
    context 'with path to non-existing file' do
      setup { @path = '/.non-existing' }

      should 'raise an exception' do
        exception = assert_raise Rwiki::FolderNotFoundError do
          Folder.new(@path)
        end

        assert_equal "cannot find #{@path}", exception.message
      end
    end

    context 'with path to the file' do
      setup { @path = './home.txt' }

      should 'raise an exception' do
        exception = assert_raise Rwiki::FolderNotFoundError do
          Folder.new(@path)
        end

        assert_equal "cannot find #{@path}", exception.message
      end
    end
  end

  context 'create method' do
    context 'with path to existing folder' do
      setup { @path = './folder' }

      should 'raise an exception' do
        exception = assert_raise Rwiki::FolderError do
          Folder.create(@path)
        end

        assert_equal "#{@path} already exists", exception.message
      end
    end

    context 'with valid path' do
      setup { @path = './new_folder' }

      should 'create a new folder' do
        assert_nothing_raised do
          folder = Folder.create(@path)

          assert File.exist?(folder.path)
          assert File.directory?(folder.path)
        end
      end
    end
  end

  context 'nodes method' do
    setup do
      @path = '.'
      @folder = Folder.new(@path)
    end

    should 'return valid tree' do
      expected_nodes = [
              {:text => 'empty_folder', :id => './empty_folder', :cls => 'folder', :children => []},
              {:text => 'folder', :id => './folder', :cls => 'folder', :children => [
                      {:text => 'test 1', :id => './folder/test 1.txt', :cls => 'page', :leaf => true},
                      {:text => 'test 2', :id => './folder/test 2.txt', :cls => 'page', :leaf => true}]},
              {:text => 'home', :id => './home.txt', :cls => 'page', :leaf => true}
      ]

      nodes = @folder.nodes
      assert_equal 3, nodes.size
      assert_equal expected_nodes, nodes
    end
  end

  context 'create_sub_folder method' do
    setup { @parent = Folder.new('.') }

    context 'for existing folder' do
      setup { @new_folder_name = 'folder' }

      should 'raise an exception' do
        exception = assert_raise Rwiki::FolderError do
          @parent.create_sub_folder(@new_folder_name)
        end

        assert_equal "./folder already exists", exception.message
      end
    end

    context 'for non-existing folder' do
      setup { @new_folder_name = 'new_folder' }

      should 'not raise an expection' do
        assert_nothing_raised do
          @parent.create_sub_folder(@new_folder_name)
        end
      end

      should 'create a new folder' do
        folder = @parent.create_sub_folder(@new_folder_name)
        assert folder
        assert_equal './new_folder', folder.path
      end
    end
  end

  context 'create_sub_page method' do
    setup { @parent = Folder.new('.') }

    context 'for existing page' do
      setup { @new_page_name = 'home.txt' }

      should 'raise an exception' do
        exception = assert_raise Rwiki::PageError do
          @parent.create_sub_page(@new_page_name)
        end

        assert_equal "./home.txt already exists", exception.message
      end
    end
  end

end
