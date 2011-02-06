require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Rwiki::Node do

  before :all do
    Rwiki::Node.rwiki_path = File.join(TmpdirHelper::TMP_DIR, 'pages')
  end

  subject { Rwiki::Node.new('folder/subfolder') }

  describe "FILE_EXTENSION constant" do
    it "should be defined" do
      Rwiki::Node.const_defined?(:"FILE_EXTENSION").should be_true
    end

    it "should be equal to 'txt'" do
      Rwiki::Node::FILE_EXTENSION.should == 'txt'
    end
  end

  describe ".rwiki_path method" do
    it "should be defined" do
      Rwiki::Node.should respond_to(:rwiki_path)
    end

    it "should return valid path" do
      Rwiki::Node.rwiki_path.should == '/tmp/rwiki_test/pages'
    end
  end

  describe ".rwiki_path= method" do
    it "should be defined" do
      Rwiki::Node.should respond_to(:rwiki_path=)
    end
  end

  describe ".sanitize_path method" do
    context "for path with trailing slashes" do
      let(:result) { Rwiki::Node.sanitize_path('/folder/subfolder/JavaScript/') }
      it "should strip the slashes" do
        result.should == "folder/subfolder/JavaScript"
      end
    end

    context "for path with extension" do
      let(:result) { Rwiki::Node.sanitize_path('folder/subfolder/JavaScript.txt') }
      it "should strip file extension" do
        result.should == "folder/subfolder/JavaScript"
      end
    end

    context "for full node path" do
      let(:result) { Rwiki::Node.sanitize_path('/tmp/rwiki_test/pages/folder/subfolder/JavaScript.txt') }
      it "should strip rwiki_path and file extension" do
        result.should == "folder/subfolder/JavaScript"
      end
    end
  end

  describe "#initialize method" do
    context "for existing path" do
      it "should not raise an exception" do
        lambda { Rwiki::Node.new('folder/test 1') }.should_not raise_error
      end
    end

    context "for non-existing path" do
      it "should raise an exception" do
        lambda { Rwiki::Node.new('non-existing') }.should raise_error(Rwiki::Node::Error, "can't find the non-existing page")
      end
    end
  end

  describe "#rwiki_path method" do
    it "should be defined" do
      subject.should respond_to(:rwiki_path)
    end

    it "should return valid rwiki path" do
      subject.rwiki_path.should == '/tmp/rwiki_test/pages'
    end
  end

  describe "#path method" do
    it "should be defined" do
      subject.should respond_to(:path)
    end

    it "should return valid node path" do
      subject.path.should == 'folder/subfolder'
    end
  end

  describe "#file_path method" do
    it "should be defined" do
      subject.should respond_to(:file_path)
    end

    it "should return valid file path" do
      subject.file_path.should == 'folder/subfolder.txt'
    end
  end

  describe "#full_path method" do
    it "should be defined" do
      subject.should respond_to(:full_path)
    end

    it "should return valid full path" do
      subject.full_path.should == '/tmp/rwiki_test/pages/folder/subfolder'
    end
  end

  describe "#full_file_path method" do
    it "should be defined" do
      subject.should respond_to(:full_file_path)
    end

    it "should return valid file path" do
      subject.full_file_path.should == '/tmp/rwiki_test/pages/folder/subfolder.txt'
    end
  end

  describe "#base_name method" do
    it "should be defined" do
      subject.should respond_to(:base_name)
    end

    it "should return valid base name" do
      subject.base_name.should == "subfolder"
    end
  end

  describe "#title method" do
    it "should be defined" do
      subject.should respond_to(:title)
    end

    it "should return valid title" do
      subject.title.should == "subfolder"
    end
  end

  describe "#to_hash method" do
    it "should be defined" do
      subject.should respond_to(:to_hash)
    end

    describe "result" do
      let(:result) { subject.to_hash }

      it "should be a hash" do
        result.should be_instance_of(Hash)
      end

      it "should contain the node path" do
        result[:path].should_not be_nil
        result[:path].should == subject.path
      end
    end
  end

  describe "#parent method" do
    it "should be defined" do
      subject.should respond_to(:parent)
    end

    it "should return valid parent" do
      parent_node = subject.parent
      parent_node.path.should == 'folder'
    end
  end

  describe "#children method" do
    it "should be defined" do
      subject.should respond_to(:children)
    end

    describe "result" do
      context "for the node with subpages" do
        let(:result) { subject.children }

        it "should be an array" do
          result.should be_instance_of(Array)
        end

        it "should contain four items" do
          result.size.should == 4
        end

        it "should contain Rwiki::Node objects" do
          result.each do |node|
            node.should be_instance_of(Rwiki::Node)
          end
        end

        it "should contain valid items" do
          result[0].title.should == "JavaScript"
          result[1].title.should == "java"
          result[2].title.should == "python"
          result[3].title.should == "ruby"
        end
      end

      context "for the node without subpages" do
        subject { Rwiki::Node.new('folder/subfolder/java') }
        let(:result) { subject.children }

        it "should return an empty array" do
          result.should be_empty
        end
      end
    end
  end

  describe "#has_children? method" do
    it "should be defined" do
      subject.should respond_to(:has_children?)
    end

    describe "result" do
      context "for node with subpages" do
        let(:result) { subject.has_children? }
        it "should return true" do
          result.should be_true
        end
      end

      context "for node without subpages" do
        subject { Rwiki::Node.new('folder/subfolder/java') }
        let(:result) { subject.has_children? }

        it "should return false" do
          result.should be_false
        end
      end
    end
  end

  describe "#leaf? method" do
    it "should be defined" do
      subject.should respond_to(:leaf?)
    end
  end

  describe "#delete method" do
    it "should be defined" do
      subject.should respond_to(:delete)
    end

    it "should remove page file" do
      full_file_path = subject.full_file_path
      subject.delete

      File.exists?(full_file_path).should be_false
    end

    it "should remove subpages" do
      full_path = subject.full_path
      children = subject.children
      subject.delete

      Dir.exist?(full_path).should be_false
      children.each do |child|
        Dir.exist?(child.full_path).should be_false  
      end
    end
  end

end
