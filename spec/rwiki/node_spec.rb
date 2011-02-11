require File.expand_path(File.join('..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::Node do

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

  its(:title) { should == "Ruby" }

  its(:to_hash) { should be_instance_of(Hash) }

  its(:parent) { should be_instance_of(Rwiki::Node) }
  its('parent.path') { should == 'Development/Programming Languages' }

  its(:children) { should be_instance_of(Array) }
  its(:children) { should be_empty }

  context "for the node with subpages" do
    subject { Rwiki::Node.new('Development/Programming Languages') }
    let(:result) { subject.children }

    its('children.size') { should == 4 }

    it "children should contain Rwiki::Node objects" do
      result.each do |node|
        node.should be_instance_of(Rwiki::Node)
      end
    end

    it "children should contain items with valid titles" do
      result[0].title.should == "Java"
      result[1].title.should == "JavaScript"
      result[2].title.should == "Python"
      result[3].title.should == "Ruby"
    end
  end

  context "node with subpages" do
    subject { Rwiki::Node.new('Development/Programming Languages') }
    its(:has_children?) { should be_true }
  end

  context "node without subpages" do
    subject { Rwiki::Node.new('Development/Programming Languages/Java') }
    its(:has_children?) { should be_false }
  end

  describe "#file_content" do
    before { subject.file_helper.expects(:read_file_content).returns('Lorem ipsum') }
    let(:result) { subject.file_content }

    it "result should contain valid cotent" do
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
