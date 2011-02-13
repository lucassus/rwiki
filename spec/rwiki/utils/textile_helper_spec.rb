require File.expand_path(File.join('..', '..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::Utils::TextileHelper do
  include Rwiki::Utils

  subject { TextileHelper.new("h1. This is a sample content") }

  its(:content) { should == "h1. This is a sample content" }

  its(:parse) { should == "<h1>This is a sample content</h1>" }

end
