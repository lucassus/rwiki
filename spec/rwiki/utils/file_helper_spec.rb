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
      result = subject.create_subpage('Foo')
      result.should == File.join(subject.full_path, 'Foo.txt')
    end
  end

  describe "#delete method" do
    it "should remove page file" do
      full_file_path = subject.full_file_path
      subject.delete

      File.exists?(full_file_path).should be_false
    end

    it "should remove subpages" do
      full_path = subject.full_path
      subject.delete

      Dir.exist?(full_path).should be_false
    end
  end

  context do
    subject { Rwiki::Utils::FileHelper.new('About') }
    
    its(:read_file_content) { should be_instance_of(String) }
    its(:read_file_content) { should == "h1. This is a sample page, zażółć gęsią jaźń" }
  end

  describe ".sanitize_path method" do
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