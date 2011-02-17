module RwikiMacros
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    include Rwiki::Utils

    def it_should_respond_with_success
      it 'should respond with success' do
        last_response.should be_ok
      end
    end

    def it_should_move_the_child_nodes(old_path, new_path)
      it "should move the child nodes" do
        Dir.exists?(FileHelper.expand_node_path(old_path)).should be_false
      end

      it "should move the child nodes to the new location" do
        Dir.exists?(FileHelper.expand_node_path(new_path)).should be_true
      end
    end
  end
end
