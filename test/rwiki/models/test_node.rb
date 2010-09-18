require File.expand_path(File.dirname(__FILE__) + '../../../helper')

class Rwiki::Models::TestNode < Test::Unit::TestCase
  include Rwiki::Models

  context 'Node#new_from_path method' do

    context 'with path to non-existing file' do
      should 'raise an expection' do
        path = './non-existing.txt'

        raised = false
        begin
          Node.new_from_path(path)
        rescue
          raised = true
        end

        assert raised
      end
    end

    context 'with path to the directory' do
      should 'retun valid instance' do
        path_to_directory =  './folder'

        folder = Node.new_from_path(path_to_directory)
        assert folder.is_a?(Folder)
      end
    end

    context 'with path to the file' do
      should 'retun valid instance' do
        path_to_file = './home.txt'

        page = Node.new_from_path(path_to_file)
        assert page.is_a?(Page)
      end
    end

  end

end
