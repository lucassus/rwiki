# encoding: utf-8

require 'spec_helper'

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
    shared_examples_for :successful_renaming do
      specify "and should return true" do
        result.should be_true
      end

      it "sets the new path" do
        subject.path.should == path_after
      end

      specify "the file for the old page name should no longer exist" do
        page_file_before = FileHelper.expand_node_file_path(path_before)
        File.exists?(page_file_before).should be_false
      end

      specify "the file for the new page should exist" do
        page_file_after = FileHelper.expand_node_file_path(path_after)
        File.exists?(page_file_after).should be_true
      end
    end

    describe "to the non-existing new name" do
      context "for page with child pages" do
        let(:path_before) { '/Home/Development/Programming Languages' }
        let(:new_name) { 'Languages' }
        let(:path_after) { '/Home/Development/Languages' }

        before { @result = subject.rename_to(new_name) }
        let(:result) { @result }

        it_behaves_like :successful_renaming

        specify "the old folder for the child pages should no longer exist" do
          child_folder_before = FileHelper.expand_node_path(path_before)
          Dir.exists?(child_folder_before).should be_false
        end

        specify "the new folder for the child pages should exist" do
          child_folder_after = FileHelper.expand_node_path(path_after)
          Dir.exists?(child_folder_after).should be_true
        end
      end

      context "for page without child pages" do
        let(:path_before) { '/Home/Development/Programming Languages/Python' }
        let(:new_name) { 'Crunchy Frog' }
        let(:path_after) { '/Home/Development/Programming Languages/Crunchy Frog' }

        subject { FileHelper.new(path_before) }
        before { @result = subject.rename_to(new_name) }
        let(:result) { @result }

        it_behaves_like :successful_renaming
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

    shared_examples_for :successful_moving do
      it "should return true" do
        result.should be_true
      end

      it "should set the new path" do
        subject.path.should == path_after
      end

      it "should move the file and corresponding directory" do
        File.exists?(FileHelper.expand_node_file_path(path_before)).should be_false
        Dir.exists?(FileHelper.expand_node_path(path_before)).should be_false
      end

      it "should move the file and corresponding directory to the new location" do
        File.exists?(FileHelper.expand_node_file_path(path_after)).should be_true
        Dir.exists?(FileHelper.expand_node_path(path_after)).should be_true
      end
    end

    shared_examples_for :unsuccessful_moving do
      it "should return false" do
        result.should be_false
      end
    end

    describe "to the valid new parent directory" do
      let(:new_parent_path) { '/Home/Personal stuff' }
      let(:path_before) { '/Home/Programming Languages' }
      let(:path_after) { '/Home/Personal stuff/Programming Languages' }

      before { @result = subject.move_to(new_parent_path) }
      let(:result) { @result }

      it_behaves_like :successful_moving
    end

    describe "to the valid new parent page" do
      let(:new_parent_path) { '/Home/About' }
      let(:path_before) { '/Home/Programming Languages' }
      let(:path_after) { '/Home/About/Programming Languages' }

      before { @result = subject.move_to('/Home/About') }
      let(:result) { @result }

      it_behaves_like :successful_moving

      it_should_move_the_child_nodes('/Home/Development/Programming Languages', '/Home/About/Programming Languages')
    end

    describe "to the non-existing parent" do
      before { @result = subject.move_to('Non-Existing') }
      let(:result) { @result }

      it_behaves_like :unsuccessful_moving
    end

    describe "to the invalid new parent" do
      before { @result = subject.move_to('/Home/Programming Languages/Java') }
      let(:result) { @result }

      it_behaves_like :unsuccessful_moving
    end

    describe "to self" do
      before { @result == subject.move_to('/Home/Programming Languages') }
      let(:result) { @result }

      it_behaves_like :unsuccessful_moving
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
      let(:result) { FileHelper.sanitize_path(FileHelper.expand_node_path('/Home/Programming Languages/JavaScript')) }
      it "should strip rwiki_path" do
        result.should == "/Home/Programming Languages/JavaScript"
      end
    end

    context "for path without a slash on the beginning" do
      let(:result) { FileHelper.sanitize_path('Home') }
      it "should add slash" do
        result.should == '/Home'
      end
    end
  end

  describe '.create_home_page!' do
    context 'when the home page does not exist' do
      before do
        home_page = Rwiki::Page.new

        # delete the home page
        FileUtils.rm_rf(home_page.file_helper.full_path)
        FileUtils.rm_rf(home_page.file_helper.full_file_path)
      end

      it "should create the home page" do
        FileHelper.create_home_page!

        home_page = nil
        lambda { home_page = Rwiki::Page.new }.should_not raise_error

        home_page.should_not be_nil
        File.exist?(home_page.file_helper.full_file_path)
      end
    end
  end

end
