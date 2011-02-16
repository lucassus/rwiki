# encoding: utf-8

require File.expand_path(File.join('..', '..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::Utils::FileHelper do
  include Rwiki::Utils

  subject { FileHelper.new('/Home/Development/Programming Languages') }

  its(:path) { should == '/Home/Development/Programming Languages' }

  its(:basename) { should == 'Programming Languages' }

  its(:file_path) { should == '/Home/Development/Programming Languages.txt' }

  its(:full_path) { should == FileHelper.expand_node_path('/Home/Development/Programming Languages') }

  its(:full_file_path) { should == FileHelper.expand_node_file_path('/Home/Development/Programming Languages') }

  its(:full_parent_path) { should == FileHelper.expand_node_path('/Home/Development') }

  describe "#add_page" do
    it "should create corresponding page file" do
      result = subject.add_page('Foo')
      File.exists?(File.join(subject.full_path, 'Foo.txt')).should be_true
    end

    it "should return a new page full path" do
      result = subject.add_page('Foo.txt')
      result.should == File.join(subject.full_path, 'Foo.txt')
    end
  end

  describe "#update_content" do
    it "should update the file content" do
      subject.update_file_content("h1. The new content, zażółć gęsią jaźń")
      subject.read_file_content.should == "h1. The new content, zażółć gęsią jaźń"
    end
  end

  describe "#delete" do
    before { subject.delete }

    it "should remove page file" do
      File.exists?(subject.full_file_path).should be_false
    end

    it "should remove subpages" do
      Dir.exist?(subject.full_file_path).should be_false
    end
  end

  describe "#rename" do
    it "should rename corresponding children directory"

    describe "to the non-existing new name" do
      before { @result = subject.rename_to('Languages') }

      it "should return true" do
        @result.should be_true
      end

      it "should set the new path" do
        subject.path.should == '/Home/Development/Languages'
      end

      it "should rename the file and the corresponding directory" do
        File.exists?(FileHelper.expand_node_file_path('/Home/Development/Programming Languages.txt')).should be_false
        Dir.exists?(FileHelper.expand_node_path('/Home/Development/Programming Languages')).should be_false

        File.exists?(FileHelper.expand_node_file_path('/Home/Development/Languages.txt')).should be_true
        Dir.exists?(FileHelper.expand_node_path('/Home/Development/Languages')).should be_true
      end
    end

    describe "to the existing new name" do
      before { @result = subject.rename_to('Databases') }

      it "should return false" do
        @result.should be_false
      end

      it "should not change the path" do
        subject.path.should == '/Home/Development/Programming Languages'
      end
    end
  end

  # TODO cleanup this test scenario
  describe "#move_to" do
    it "should not move the child directory if it does not exist"
    it "should delete the child directory if last child was moved"
    it "should return false on move to the same node"

    describe "to the valid new parent directory" do
      before { @result = subject.move_to('/Home/Personal stuff') }
      let(:result) { @result }

      it_should_return_true
      it_should_set_the_new_path('/Home/Personal stuff/Programming Languages')
      it_should_move_node('/Home/Programming Languages', '/Home/Personal stuff/Programming Languages')
    end

    describe "to the valid new parent page" do
      before { @result = subject.move_to('/Home/About') }
      let(:result) { @result }

      it_should_return_true
      it_should_set_the_new_path('/Home/About/Programming Languages')
      it_should_move_node('/Home/Development/Programming Languages', '/Home/About/Programming Languages')
      it_should_move_the_child_nodes('/Home/Development/Programming Languages', '/Home/About/Programming Languages')
    end

    describe "to the non-existing parent" do
      before { @result = subject.move_to('Non-Existing') }
      let(:result) { @result }

      it_should_return_false
    end

    describe "to the invalid new parent" do
      before { @result = subject.move_to('/Home/Programming Languages/Java') }
      let(:result) { @result }

      it_should_return_false
    end

    describe "to self" do
      before { @result == subject.move_to('/Home/Programming Languages') }
      let(:result) { @result }

      it_should_return_false
    end
  end

  context do
    subject { FileHelper.new('/Home/About') }

    its(:read_file_content) { should be_instance_of(String) }
    its(:read_file_content) { should == "h1. This is a sample page, zażółć gęsią jaźń" }
  end

  describe ".sanitize_path" do
    context "for path with extension" do
      let(:result) { FileHelper.sanitize_path('/Home/Programming Languages/JavaScript.txt') }
      it "should strip file extension" do
        result.should == "/Home/Programming Languages/JavaScript"
      end
    end

    context "for full node path" do
      let(:result) { FileHelper.sanitize_path(FileHelper.expand_node_path('/Home/Programming Languages/JavaScript.txt')) }
      it "should strip rwiki_path and file extension" do
        result.should == "/Home/Programming Languages/JavaScript"
      end
    end
  end

end