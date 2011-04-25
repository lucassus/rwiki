require 'spec_helper'

describe Rwiki::Utils::TextileHelper do
  include Rwiki::Utils
  subject { TextileHelper.new(content) }

  context "with a sample content" do
    let(:content) { "h1. This is a sample content" }

    its(:content) { should == "h1. This is a sample content" }
    its(:parsed_content) { should == %Q{<h1><a name="This-is-a-sample-content">This is a sample content</a></h1>} }
    its(:textile_toc) { should == '# "This is a sample content":#This-is-a-sample-content' }
  end

  context "with a complex content" do
    let(:content) do
      <<-CONTENT
      h1. This is the page title

      Lorem ipsum..

      h2. Section 1

      h3. Section 1.1

      ..dolor etc.

      h3. Section 1.2

      h3. Section 1.3

      h4. Section 1.3.1

      h2. Section 2

      h3. Yet another section
      CONTENT
    end

    describe "#parsed_content" do
      let(:result) { subject.parsed_content }
      it "should generate html with page content" do
        result.should_not be_nil

        result.should include('<h1><a name="This-is-the-page-title">This is the page title</a></h1>')
        result.should include('Lorem ipsum..')
        result.should include('<h3><a name="Yet-another-section">Yet another section</a></h3>')
      end

      it "should not change the original content" do
        subject.content.should == content
      end
    end

    describe "#textile_toc" do
      it "should generate a textile code with the Table Of Content" do
        expected_toc = <<-TOC.gsub(/^\s*/, '').strip
          # "This is the page title":#This-is-the-page-title
          ## "Section 1":#Section-1
          ### "Section 1.1":#Section-1.1
          ### "Section 1.2":#Section-1.2
          ### "Section 1.3":#Section-1.3
          #### "Section 1.3.1":#Section-1.3.1
          ## "Section 2":#Section-2
          ### "Yet another section":#Yet-another-section
        TOC

        subject.textile_toc.should == expected_toc
      end
    end
  end

end
