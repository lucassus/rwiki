require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Rwiki::FileUtils do

  before :all do
    Rwiki.configuration.rwiki_path = File.join(TmpdirHelper::TMP_DIR, 'pages')
    Rwiki.configuration.page_file_extension = 'txt'
  end

  subject { Rwiki::FileUtils.new('Development/Programming Languages') }

  describe "#path method" do
    it "should return valid node path" do
      subject.path.should == 'Development/Programming Languages'
    end
  end

  describe "#file_path method" do
    it "should return valid file path" do
      subject.file_path.should == 'Development/Programming Languages.txt'
    end
  end

  describe "#full_path method" do
    it "should return valid full path" do
      subject.full_path.should == '/tmp/rwiki_test/pages/Development/Programming Languages'
    end
  end

  describe "#full_file_path method" do
    it "should return valid file path" do
      subject.full_file_path.should == '/tmp/rwiki_test/pages/Development/Programming Languages.txt'
    end
  end

  describe "#base_name method" do
    it "should return valid base name" do
      subject.base_name.should == "Programming Languages"
    end
  end

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

  describe "#full_parent_path" do
    it "should return valid full parent path" do
      subject.full_parent_path.should == '/tmp/rwiki_test/pages/Development'
    end
  end

  describe ".sanitize_path method" do
    context "for path with trailing slashes" do
      let(:result) { Rwiki::FileUtils.sanitize_path('/Development/Programming Languages/JavaScript/') }
      it "should strip the slashes" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end

    context "for path with extension" do
      let(:result) { Rwiki::FileUtils.sanitize_path('Development/Programming Languages/JavaScript.txt') }
      it "should strip file extension" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end

    context "for full node path" do
      let(:result) { Rwiki::FileUtils.sanitize_path('/tmp/rwiki_test/pages/Development/Programming Languages/JavaScript.txt') }
      it "should strip rwiki_path and file extension" do
        result.should == "Development/Programming Languages/JavaScript"
      end
    end
  end

end