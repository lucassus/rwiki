# encoding: utf-8

require File.expand_path(File.join('..', '..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::Utils::FileHelper do

  subject { Rwiki::Utils::FileHelper.new('Development/Programming Languages') }

  its(:path) { should == 'Development/Programming Languages' }

  its(:file_path) { should == 'Development/Programming Languages.txt' }

  its(:full_path) { should == '/tmp/rwiki_test/pages/Development/Programming Languages' }

  its(:full_file_path) { should == '/tmp/rwiki_test/pages/Development/Programming Languages.txt' }

  its(:full_parent_path) { should == '/tmp/rwiki_test/pages/Development' }

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
        File.exists?('/tmp/rwiki_test/pages/Development/Programming Languages.txt').should be_false
        Dir.exists?('/tmp/rwiki_test/pages/Development/Programming Languages').should be_false

        File.exists?('/tmp/rwiki_test/pages/Development/Languages.txt').should be_true
        Dir.exists?('/tmp/rwiki_test/pages/Development/Languages').should be_true
      end
    end

    describe "to the existing new name" do
      before { @result = subject.rename('Databases') }

      it "should return false" do
        @result.should be_false
      end

      it "should not change the path" do
        subject.path.should == 'Development/Programming Languages'
      end
    end
  end

  context do
    subject { Rwiki::Utils::FileHelper.new('About') }

    its(:read_file_content) { should be_instance_of(String) }
    its(:read_file_content) { should == "h1. This is a sample page, zażółć gęsią jaźń" }
  end

  describe ".sanitize_path" do
    context "for path with trailing slashes" do
      let(:result) { Rwiki::Utils::FileHelper.sanitize_path('/Development/Programming Languages/JavaScript/') }
      it "should strip the slashes" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end

    context "for path with extension" do
      let(:result) { Rwiki::Utils::FileHelper.sanitize_path('Development/Programming Languages/JavaScript.txt') }
      it "should strip file extension" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end

    context "for full node path" do
      let(:result) { Rwiki::Utils::FileHelper.sanitize_path('/tmp/rwiki_test/pages/Development/Programming Languages/JavaScript.txt') }
      it "should strip rwiki_path and file extension" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end
  end

end