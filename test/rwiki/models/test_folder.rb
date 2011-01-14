require File.expand_path(File.dirname(__FILE__) + '../../../helper')

class Rwiki::Models::TestFolder < Test::Unit::TestCase
  include Rwiki::Models

  context 'The Folder class' do
    context ':new method' do
      context 'with path to non-existing file' do
        setup { @path = '/.non-existing' }

        should 'raise an exception' do
          exception = assert_raise Rwiki::NodeNotFoundError do
            Folder.new(@path)
          end

          assert_equal "cannot find #{@path}", exception.message
        end
      end

      context 'with path to the file' do
        setup { @path = './home.txt' }

        should 'raise an exception' do
          exception = assert_raise Rwiki::NodeNotFoundError do
            Folder.new(@path)
          end

          assert_equal "cannot find #{@path}", exception.message
        end
      end

      context 'with valid path' do
        setup do
          @path = './folder'
          assert_nothing_raised do
            @folder = Folder.new(@path)
          end
        end

        should 'create a valid instance' do
          assert @folder
          assert_equal @path, @folder.path
        end
      end
    end
  end

  context 'A folder instance' do
    context ':title method' do
      should 'return valid title' do
        folder = Folder.new('./folder')
        assert_equal 'folder', folder.base_name

        folder = Folder.new('./folder/subfolder')
        assert_equal 'subfolder', folder.base_name
      end
    end

    context ':nodes method' do
      setup do
        @path = '.'
        @folder = Folder.new(@path)
      end

      should_eventually 'return valid tree' do
        # TODO cls is redundant
        expected_nodes = [
          {:text => 'empty_folder', :id => 'empty_folder', :cls => 'folder', :children => []},
          {:text => 'folder', :id => 'folder', :cls => 'folder', :children => [
              {:text => 'subfolder', :id => 'subfolder', :cls => 'folder', :children => [
                  {:text => 'ruby', :id => 'ruby.txt', :cls => 'page', :leaf => true}]},
              {:text => 'test 1', :id => 'test 1.txt', :cls => 'page', :leaf => true},
              {:text => 'test 2', :id => 'test 2.txt', :cls => 'page', :leaf => true},
              {:text => 'test', :id => 'test.txt', :cls => 'page', :leaf => true}]},
          {:text => 'home', :id => 'home.txt', :cls => 'page', :leaf => true},
          {:text => 'subfolder', :id => 'subfolder', :cls => 'folder', :children => []},
          {:text => 'test', :id => 'test.txt', :cls => 'page', :leaf => true}
        ]

        nodes = @folder.nodes
        assert_equal expected_nodes.size, nodes.size
        assert_equal expected_nodes, nodes
      end
    end

    context ':create_sub_folder method' do
      setup { @parent = Folder.new('.') }

      context 'for existing folder' do
        setup { @new_folder_name = 'folder' }

        should 'raise an exception' do
          exception = assert_raise Rwiki::NodeError do
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

        should 'return a new folder instance' do
          folder = @parent.create_sub_folder(@new_folder_name)
          assert folder
          assert_equal './new_folder', folder.path
        end

        should 'create a new directory' do
          @parent.create_sub_folder(@new_folder_name)
          directory_path = File.join(@parent.full_path, @new_folder_name)
          
          assert File.exist?(directory_path), "directory #{directory_path} does not exist"
          assert File.directory?(directory_path)
        end
      end
    end

    context ':create_sub_page method' do
      setup { @parent = Folder.new('.') }

      context 'for existing page' do
        setup { @new_page_name = 'home.txt' }

        should 'raise an exception' do
          exception = assert_raise Rwiki::NodeError do
            @parent.create_sub_page(@new_page_name)
          end

          assert_equal "./home.txt already exists", exception.message
        end
      end

      context 'for non-existing page' do
        setup do
          @new_page_name = 'new_page.txt'

          assert_nothing_raised do
            @new_page = @parent.create_sub_page(@new_page_name)
          end
        end

        should 'return a new page instance' do
          assert @new_page
          assert_equal './new_page.txt', @new_page.path
          assert_equal '', @new_page.raw_content
          assert_equal '', @new_page.html_content
        end

        should 'create a file' do
          file_path = File.join(@parent.full_path, @new_page_name)
          assert file_path.end_with?(Node::PAGE_FILE_EXTENSION)
          assert File.exists?(file_path), "file #{file_path} does not exist"
          assert File.file?(file_path)
        end
      end
    end

    context ':rename method' do
      setup { @folder = Folder.new('./folder') }

      context 'for existing folder' do
        setup { @new_name = 'empty_folder' }

        should 'raise an exception' do
          exception = assert_raise Rwiki::NodeError do
            @folder.rename(@new_name)
          end

          assert_equal "./empty_folder already exists", exception.message
        end
      end

      context 'for non-exist folder' do
        setup do
          @new_name = 'folder_with_new_name'
          @folder = Folder.new('./folder')

          assert_nothing_raised do
            @folder.rename(@new_name)
          end
        end

        should 'rename directory' do
          old_full_path = File.join(@folder.parent_folder.full_path, 'folder')
          assert !File.exist?(old_full_path), "#{old_full_path} is still exists"

          new_full_path = File.join(@folder.parent_folder.full_path, 'folder_with_new_name')
          assert File.exist?(new_full_path), "#{new_full_path} is not exist"
        end

        should 'set valid path and base_name' do
          assert_equal "./folder_with_new_name", @folder.path
          assert_equal "folder_with_new_name", @folder.base_name
        end
      end
    end
  end
end
