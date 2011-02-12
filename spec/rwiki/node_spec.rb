require File.expand_path(File.join('..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::Node do
  include Rwiki

  describe "the root node" do
    before { @root_node = Node.new }
    subject { @root_node }

    its(:is_root?) { should be_true }
    its(:title) { should == Rwiki.configuration.root_page_name }
    its(:parent) { should be_nil }

    its(:to_tree_node_hash) { should be_instance_of(Hash) }
    context "#to_tree_node_hash" do
      subject { @root_node.to_tree_node_hash }

      its([:text]) { should == 'Home' }
      its([:leaf?]) { should be_false }
    end

    describe "#tree" do
      let(:result) { subject.tree }

      it "result should be an array" do
        result.should be_instance_of(Array)
      end

      it "result should contain three items" do
        result.size.should == 4
      end
    end
  end

  before { @node = Node.new('/Home/Development/Programming Languages/Ruby') }
  subject { @node }

  describe "#initialize" do
    context "for existing path" do
      it "should not raise an exception" do
        lambda { Node.new('/Home/Development/Programming Languages/Ruby') }.should_not raise_error
      end
    end

    context "for non-existing path" do
      it "should raise an exception" do
        lambda { Node.new('non-existing') }.should raise_error(Node::Error, "can't find the non-existing page")
      end
    end
  end

  its(:is_root?) { should be_false }

  its(:title) { should == "Ruby" }

  its(:to_hash) { should be_instance_of(Hash) }

  its(:parent) { should be_instance_of(Node) }
  its('parent.path') { should == '/Home/Development/Programming Languages' }

  its(:children) { should be_instance_of(Array) }
  its(:children) { should be_empty }

  context "for the node with child pages" do
    subject { Node.new('/Home/Development/Programming Languages') }
    let(:result) { subject.children }

    its('children.size') { should == 4 }

    it "children should contain Node objects" do
      result.each do |node|
        node.should be_instance_of(Node)
      end
    end

    it "children should contain items with valid titles" do
      result[0].title.should == "Java"
      result[1].title.should == "JavaScript"
      result[2].title.should == "Python"
      result[3].title.should == "Ruby"
    end
  end

  context "node with child pages" do
    subject { Node.new('/Home/Development/Programming Languages') }
    its(:has_children?) { should be_true }
  end

  context "node without child pages" do
    subject { Node.new('/Home/Development/Programming Languages/Java') }
    its(:has_children?) { should be_false }
  end

  describe "#file_content" do
    before { subject.file_helper.expects(:read_file_content).returns('Lorem ipsum') }
    let(:result) { subject.file_content }

    it "result should contain valid content" do
      result.should == "Lorem ipsum"
    end
  end

  describe "#html_content" do
    before { subject.file_helper.expects(:read_file_content).returns('h1. Lorem ipsum') }
    let(:result) { subject.html_content }

    it "result should be a String instance" do
      result.should be_instance_of(String)
    end

    it "result should contain valid html content" do
      result.should == "<h1>Lorem ipsum</h1>"
    end
  end

  describe "#add_page" do
    let(:result) { subject.add_page('Regular Expressions') }

    it "result should be a Node instance" do
      result.should be_instance_of(Node)
    end

    it "result should have valid path" do
      result.path.should == '/Home/Development/Programming Languages/Ruby/Regular Expressions'
    end
  end

end
