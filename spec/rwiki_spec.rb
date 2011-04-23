require 'spec_helper'

describe Rwiki do

  describe Rwiki::Configuration do
    subject { Rwiki::Configuration.instance }
    before { subject.rwiki_path = '/tmp/rwiki_test/fixtures' }

    it { should be_instance_of(Rwiki::Configuration) }

    its(:rwiki_path) { should == '/tmp/rwiki_test/fixtures' }
    its(:root_page_name) { should == 'Home' }
    its(:root_page_path) { should == '/Home' }
    its(:page_file_extension) { should == 'txt' }

    its(:root_page_full_path) { should == '/tmp/rwiki_test/fixtures/Home' }
    its(:root_page_full_file_path) { should == '/tmp/rwiki_test/fixtures/Home.txt' }

    its(:version) { should == '0.2.4' }
  end

end
