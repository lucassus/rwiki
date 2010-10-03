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

    context ':move method' do
      should 'raise an exception if the new parent is a page' do
        node = Node.new_from_path('./test.txt')
        new_parent = Page.new('./test.txt')

        exception = assert_raise Rwiki::NodeError do
          node.move(new_parent)
        end
        assert_equal 'cannot move node', exception.message
      end

      should 'raise an exception if the new parent has a node with the same name' do
        node = Node.new_from_path('./test.txt')
        new_parent = Node.new_from_path('./folder')

        exception = assert_raise Rwiki::NodeError do
          node.move(new_parent)
        end
        assert_equal 'cannot move node', exception.message
      end

      context 'on page' do
        setup do
          @node = Node.new_from_path('./test.txt')
          @new_parent = Folder.new('./folder/subfolder')
          assert_nothing_raised do
            @node.move(@new_parent)
          end
        end

        should 'set a new path' do
          assert_equal './folder/subfolder/test.txt', @node.path
        end

        should 'move a file' do
          assert !File.exists?(File.join(Node.working_path, './test.txt'))
          assert File.exists?(File.join(Node.working_path, './folder/subfolder/test.txt'))
        end
      end

      context 'on folder' do
        setup do
          @node = Folder.new('./folder')
          @new_parent = Folder.new('./empty_folder')
          assert_nothing_raised do
            @node.move(@new_parent)
          end
        end

        should 'set a new path' do
          assert_equal './empty_folder/folder', @node.path
        end

        should 'move a folder' do
          assert !File.exists?(File.join(Node.working_path, './folder'))
          assert File.exists?(File.join(Node.working_path, './empty_folder/folder'))
        end

        should 'move all files' do
          assert File.exists?(File.join(Node.working_path, './empty_folder/folder/subfolder/ruby.txt'))
          assert File.exists?(File.join(Node.working_path, './empty_folder/folder/test 1.txt'))
          assert File.exists?(File.join(Node.working_path, './empty_folder/folder/test 2.txt'))
        end
      end
    end
  end
end
