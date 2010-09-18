require File.expand_path(File.dirname(__FILE__) + '../../../helper')

class Rwiki::Models::TestNode < Test::Unit::TestCase
  include Rwiki::Models

  context 'Node#new_from_path method' do

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

  context 'Node#base_name method' do
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

end
