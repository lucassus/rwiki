require File.expand_path(File.join('..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::Page do
  include Rwiki

  describe '.root' do
    it "should return the home page instance" do
      Page.root.is_root?.should be_true
    end
  end

  describe ".new" do
    context "without arguments" do
      it "should return the home page instance" do
        page = Page.new
        page.is_root?.should be_true
      end
    end

    context "for existing path" do
      it "should not raise an exception" do
        lambda { Page.new('/Home/Development/Programming Languages/Ruby') }.should_not raise_error
      end
    end

    context "for non-existing path" do
      it "should raise an exception" do
        lambda { Page.new('non-existing') }.should raise_error(Page::Error, "can't find the non-existing page")
      end
    end
  end

  describe "the root page instance" do
    let(:root_page) { Page.new }
    subject { root_page }

    its(:path) { should == '/Home' }
    its(:is_root?) { should be_true }
    its(:title) { should == Rwiki.configuration.root_page_name }
    its(:parent) { should be_nil }

    its(:to_tree_node_hash) { should be_instance_of(Hash) }
    context "#to_tree_node_hash" do
      subject { root_page.to_tree_node_hash }

      its([:text]) { should == 'Home' }
      its([:leaf?]) { should be_false }
    end

    describe "#tree" do
      let(:result) { subject.tree }

      it "result should be an array" do
        result.should be_instance_of(Array)
      end

      it "result should contain three items" do
        result.size.should == 3
      end
    end

    describe "#rename_to" do
      it "should raise an exception" do
        lambda { subject.rename_to('Foo') }.should raise_error(Page::Error, "cannot rename the Home page")
      end
    end

    describe "#move_to" do
      it "should raise an exception" do
        other_page = Rwiki::Page.new('/Home/Development')
        lambda { subject.move_to(other_page) }.should raise_error(Page::Error, "cannot move the Home page")
      end
    end

    describe "#delete" do
      it "should raise an exception" do
        lambda { subject.delete }.should raise_error(Page::Error, "cannot delete the Home page")
      end
    end
  end

  describe "the page instance" do
    let(:page) { Page.new('/Home/Development/Programming Languages/Ruby') }
    subject { page }

    its(:path) { should == '/Home/Development/Programming Languages/Ruby' }
    its(:is_root?) { should be_false }
    its(:title) { should == "Ruby" }
    its(:to_hash) { should be_instance_of(Hash) }

    its(:parent) { should be_instance_of(Page) }
    its('parent.path') { should == '/Home/Development/Programming Languages' }

    its(:children) { should be_instance_of(Array) }
    its(:children) { should be_empty }

    context "for the node with child pages" do
      subject { Page.new('/Home/Development/Programming Languages') }
      let(:result) { subject.children }

      its('children.size') { should == 4 }

      it "children should contain Node objects" do
        result.each do |node|
          node.should be_instance_of(Page)
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
      subject { Page.new('/Home/Development/Programming Languages') }
      its(:has_children?) { should be_true }
    end

    context "node without child pages" do
      subject { Page.new('/Home/Development/Programming Languages/Java') }
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
        result.should be_instance_of(Page)
      end

      it "result should have valid path" do
        result.path.should == '/Home/Development/Programming Languages/Ruby/Regular Expressions'
      end
    end

    describe "#update_file_content" do
      before { subject.update_file_content("h1. The new content") }

      it "should update the file content" do
        subject.file_content.should == "h1. The new content"
      end

      it "should update the html content" do
        subject.html_content.should == "<h1>The new content</h1>"
      end
    end

    describe "#rename_to" do
      context 'when renaming is successful' do
        it "should rename the node" do
          subject.file_helper.expects(:rename_to).with('Lisp').returns(true)
          subject.rename_to('Lisp')
        end
      end

      context 'when renaming was fail' do
        it "should not rename the node" do
          subject.file_helper.expects(:rename_to).with('Stupid PHP').returns(false)
          subject.rename_to('Stupid PHP')
        end
      end
    end

    describe "#move_to" do
      it "should move the node" do
        new_parent = Page.new('/Home/About')
        subject.file_helper.expects(:move_to).with('/Home/About').returns(true)

        subject.move_to(new_parent).should be_true
      end
    end

    describe "#delete" do
      it "should delete the node" do
        subject.file_helper.expects(:delete)
        subject.delete
      end
    end
  end

  describe "#findgrep" do
    let(:page) { Page.new('/Home/Development') }
    subject { page }

    describe "results" do
      let(:results) { page.findgrep('foobar') }
      subject { results }

      it { should be_instance_of(Array) }
      it { should have(4).items }

      describe "first result" do
        subject { results[0] }

        it { should be_instance_of(Hash) }
        its([:path]) { should == '/Home/Development/Databases' }
        its([:line]) { should == 'FooBar' }
      end

      describe "second result" do
        subject { results[1] }

        it { should be_instance_of(Hash) }
        its([:path]) { should == '/Home/Development/Databases' }
        its([:line]) { should == 'and another FooBar' }
      end

      describe "third result" do
        subject { results[2] }

        it { should be_instance_of(Hash) }
        its([:path]) { should == '/Home/Development/Databases/MySQL' }
        its([:line]) { should == "SELECT * FROM users WHERE login LIKE '%foobar%';" }
      end

      describe "fourth result" do
        subject { results[3] }

        it { should be_instance_of(Hash) }
        its([:path]) { should == '/Home/Development/Programming Languages' }
        its([:line]) { should == 'h2. FooBar' }
      end
    end
  end
end
