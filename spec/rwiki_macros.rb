module RwikiMacros
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def it_should_respond_with_success
      it 'should respond with success' do
        last_response.should be_ok
      end
    end

    def it_should_return_true
      it "should return true" do
        result.should be_true
      end
    end

    def it_should_return_false
      it "should return false" do
        result.should be_false
      end
    end

    def it_should_move_node(old_path, new_path)
      it "should move the file and corresponding directory" do
        File.exists?(Rwiki::Utils::FileHelper.expand_node_file_path(old_path)).should be_false
        Dir.exists?(Rwiki::Utils::FileHelper.expand_node_path(old_path)).should be_false
      end

      it "should move the file and corresponding directory to the new location" do
        File.exists?(Rwiki::Utils::FileHelper.expand_node_file_path(new_path)).should be_true
        Dir.exists?(Rwiki::Utils::FileHelper.expand_node_path(new_path)).should be_true
      end
    end

    def it_should_move_the_child_nodes(old_path, new_path)
      it "should move the child nodes" do
        Dir.exists?(Rwiki::Utils::FileHelper.expand_node_path(old_path)).should be_false
      end

      it "should move the child nodes to the new location" do
        Dir.exists?(Rwiki::Utils::FileHelper.expand_node_path(new_path)).should be_true
      end
    end

    def it_should_set_the_new_path(expected_path)
      it "should set the new path" do
        subject.path.should == expected_path
      end
    end
  end
end
