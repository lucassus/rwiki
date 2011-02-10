require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Rwiki::Node do

  before :all do
    Rwiki.configuration.rwiki_path = File.join(TmpdirHelper::TMP_DIR, 'pages')
    Rwiki.configuration.page_file_extension = 'txt'
  end

  subject { Rwiki::Node.new('Development/Programming Languages/Ruby') }

  describe ".tree method" do
    subject { Rwiki::Node }
    let(:result) { subject.tree }

    it "result should be an array" do
      result.should be_instance_of(Array)
    end

    it "result should contain three items" do
      result.size.should == 4
    end
  end

  describe "#initialize method" do
    context "for existing path" do
      it "should not raise an exception" do
        lambda { Rwiki::Node.new('Development/Programming Languages/Ruby') }.should_not raise_error
      end
    end

    context "for non-existing path" do
      it "should raise an exception" do
        lambda { Rwiki::Node.new('non-existing') }.should raise_error(Rwiki::Node::Error, "can't find the non-existing page")
      end
    end
  end

  describe "#title method" do
    it "should return valid title" do
      subject.title.should == "Ruby"
    end
  end

  describe "#to_hash method" do
    let(:result) { subject.to_hash }

    it "result should be a hash" do
      result.should be_instance_of(Hash)
    end

    it "result should contain the node path" do
      result[:path].should_not be_nil
      result[:path].should == subject.path
    end
  end

  describe "#parent method" do
    it "should return valid parent" do
      parent_node = subject.parent
      parent_node.path.should == 'Development/Programming Languages'
    end
  end

  describe "#children method" do
    context "for the node with subpages" do
      subject { Rwiki::Node.new('Development/Programming Languages') }
      let(:result) { subject.children }

      it "result should be an array" do
        result.should be_instance_of(Array)
      end

      it "result should contain four items" do
        result.size.should == 4
      end

      it "result should contain Rwiki::Node objects" do
        result.each do |node|
          node.should be_instance_of(Rwiki::Node)
        end
      end

      it "result should contain valid items" do
        result[0].title.should == "Java"
        result[1].title.should == "JavaScript"
        result[2].title.should == "Python"
        result[3].title.should == "Ruby"
      end
    end

    context "for the node without subpages" do
      subject { Rwiki::Node.new('Development/Programming Languages/Java') }
      let(:result) { subject.children }

      it "result should return an empty array" do
        result.should be_empty
      end
    end
  end

  describe "#has_children? method" do
    context "for node with subpages" do
      subject { Rwiki::Node.new('Development/Programming Languages') }
      let(:result) { subject.has_children? }
      
      it "result should return true" do
        result.should be_true
      end
    end

    context "for node without subpages" do
      subject { Rwiki::Node.new('Development/Programming Languages/Java') }
      let(:result) { subject.has_children? }

      it "result should return false" do
        result.should be_false
      end
    end
  end

  describe "#create_subpage" do
    let(:result) { subject.create_subpage('Regular Expressions') }

    it "result should be a Node intance" do
      result.should be_instance_of(Rwiki::Node)
    end

    it "result should have valid path" do
      result.path.should == 'Development/Programming Languages/Ruby/Regular Expressions'
    end
  end

end
