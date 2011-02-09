require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Rwiki::FileUtils do

  before :each do
    Rwiki.configuration.rwiki_path = File.join(TmpdirHelper::TMP_DIR, 'pages')
  end

  subject { Rwiki::FileUtils.new('folder/subfolder') }

  describe "#path method" do
    it "should return valid node path" do
      subject.path.should == 'folder/subfolder'
    end
  end

  describe "#file_path method" do
    it "should return valid file path" do
      subject.file_path.should == 'folder/subfolder.txt'
    end
  end

  describe "#full_path method" do
    it "should return valid full path" do
      subject.full_path.should == '/tmp/rwiki_test/pages/folder/subfolder'
    end
  end

  describe "#full_file_path method" do
    it "should return valid file path" do
      subject.full_file_path.should == '/tmp/rwiki_test/pages/folder/subfolder.txt'
    end
  end

  describe "#base_name method" do
    it "should return valid base name" do
      subject.base_name.should == "subfolder"
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

  describe "#full_parent_path" do
    it "should return valid full parent path" do
      subject.full_parent_path.should == '/tmp/rwiki_test/pages/folder'
    end
  end

end