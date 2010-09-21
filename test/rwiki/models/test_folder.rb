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

end
