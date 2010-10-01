require File.expand_path(File.dirname(__FILE__) + '../../../helper')

class Rwiki::Models::TestNode < Test::Unit::TestCase
  include Rwiki::Models

  context 'Node class' do
    should 'respond to :working_path and :working_path=' do
      assert Node.respond_to?(:working_path)
      assert Node.respond_to?(:working_path=)
    end

    context ':new_from_path method' do
      context 'with path to the directory' do
        setup { @path = './folder' }

        should 'retun valid instance' do
          folder = Node.new_from_path(@path)
          assert folder.is_a?(Folder)
        end
      end

      context 'with path to the file' do
        setup { @path = './home.txt' }

        should 'retun valid instance' do
          page = Node.new_from_path(@path)
          assert page.is_a?(Page)
        end
      end
    end

    context ':full_path_for method' do
      should 'return valid path' do
        assert_equal File.join(@working_path, 'empty_folder'), Node.full_path_for('empty_folder')
        assert_equal File.join(@working_path, 'folder/test 1.txt'), Node.full_path_for('folder/test 1.txt')
      end
    end
  end

  context 'A node instance' do
    context ':full_path method' do
      setup { @path = './home.txt' }

      should 'return valid full path' do
        page = Page.new(@path)
        assert_equal File.join(Rwiki::Models::Node.working_path, 'home.txt'), page.full_path
      end
    end

    context ':base_name method' do
      context 'for page' do
        setup { @path = './home.txt' }

        should 'return valid page basename' do
          page = Page.new(@path)
          assert_equal 'home.txt', page.base_name
        end
      end

      context 'for folder' do
        setup { @path = './folder' }

        should 'return valid folder basename' do
          page = Folder.new(@path)
          assert_equal 'folder', page.base_name
        end
      end
    end

    context ':parent_folder method' do
      setup { @node = Node.new_from_path('./folder/test 1.txt') }

      should 'return valid parent folder' do
        parent_folder = @node.parent_folder
        assert parent_folder
        assert_kind_of Folder, parent_folder
        assert_equal './folder', parent_folder.path
      end
    end
  end
end
