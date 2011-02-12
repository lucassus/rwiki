# encoding: utf-8

require File.expand_path(File.join('..', '..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::Utils::FileHelper do
  include Rwiki::Utils

  subject { FileHelper.new('Development/Programming Languages') }

  its(:path) { should == 'Development/Programming Languages' }

  its(:basename) { should == 'Programming Languages' }

  its(:file_path) { should == 'Development/Programming Languages.txt' }

  its(:full_path) { should == FileHelper.expand_node_path('Development/Programming Languages') }

  its(:full_file_path) { should == FileHelper.expand_node_file_path('Development/Programming Languages') }

  its(:full_parent_path) { should == FileHelper.expand_node_path('Development') }

  describe "#create_subpage" do
    it "should create corresponding page file" do
      result = subject.create_subpage('Foo')
      File.exists?(File.join(subject.full_path, 'Foo.txt')).should be_true
    end

    it "should return a new page full path" do
      result = subject.create_subpage('Foo.txt')
      result.should == File.join(subject.full_path, 'Foo.txt')
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
    describe "to the non-existing new name" do
      before { @result = subject.rename('Languages') }

      it "should return true" do
        @result.should be_true
      end

      it "should set the new path" do
        subject.path.should == 'Development/Languages'
      end

      it "should rename the file and the corresponding directory" do
        File.exists?(FileHelper.expand_node_file_path('Development/Programming Languages.txt')).should be_false
        Dir.exists?(FileHelper.expand_node_path('Development/Programming Languages')).should be_false

        File.exists?(FileHelper.expand_node_file_path('Development/Languages.txt')).should be_true
        Dir.exists?(FileHelper.expand_node_path('Development/Languages')).should be_true
      end
    end

    describe "to the existing new name" do
      before { @result = subject.rename('Databases.txt') }

      it "should return false" do
        @result.should be_false
      end

      it "should not change the path" do
        subject.path.should == 'Development/Programming Languages'
      end
    end
  end

  describe "#move" do
    describe "to the valid new parent (directory)" do
      before { @result = subject.move('Personal stuff') }

      it "should return true" do
        @result.should be_true
      end

      it "should set the new path" do
        subject.path.should == 'Personal stuff/Programming Languages'
      end

      it "should move the file and the corresponding directory" do
        File.exists?(FileHelper.expand_node_file_path('Development/Programming Languages')).should be_false
        Dir.exists?(FileHelper.expand_node_path('Development/Programming Languages')).should be_false

        File.exists?(FileHelper.expand_node_file_path('Personal stuff/Programming Languages')).should be_true
        Dir.exists?(FileHelper.expand_node_path('Personal stuff/Programming Languages')).should be_true
      end
    end

    describe "to the valid new parent (page)" do
      before { @result = subject.move('Home') }

      it "should return true" do
        @result.should be_true
      end

      it "should set the new path" do
        subject.path.should == 'Home/Programming Languages'
      end

      it "should move the file and the corresponding directory" do
        File.exists?(FileHelper.expand_node_file_path('Development/Programming Languages')).should be_false
        Dir.exists?(FileHelper.expand_node_path('Development/Programming Languages')).should be_false

        File.exists?(FileHelper.expand_node_file_path('Home')).should be_true
        File.exists?(FileHelper.expand_node_file_path('Home/Programming Languages')).should be_true
        Dir.exists?(FileHelper.expand_node_path('Home/Programming Languages')).should be_true
      end
    end

    describe "to the non-existing parent" do
      before { @result = subject.move('Non-Existing') }

      it "should return false" do
        @result.should be_false
      end
    end

    describe "to the invalid new parent" do
      before { @result = subject.move('Development/Programming Languages/Java') }

      it "should return false" do
        @result.should be_false
      end
    end

    describe "to self" do
      before { @result == subject.move('Development/Programming Languages') }

      it "should return false" do
        @result.should be_false
      end
    end
  end

  context do
    subject { FileHelper.new('About') }

    its(:read_file_content) { should be_instance_of(String) }
    its(:read_file_content) { should == "h1. This is a sample page, zażółć gęsią jaźń" }
  end

  describe ".sanitize_path" do
    context "for path with trailing slashes" do
      let(:result) { FileHelper.sanitize_path('/Development/Programming Languages/JavaScript/') }
      it "should strip the slashes" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end

    context "for path with extension" do
      let(:result) { FileHelper.sanitize_path('Development/Programming Languages/JavaScript.txt') }
      it "should strip file extension" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end

    context "for full node path" do
      let(:result) { FileHelper.sanitize_path(FileHelper.expand_node_path('Development/Programming Languages/JavaScript.txt')) }
      it "should strip rwiki_path and file extension" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end
  end

end