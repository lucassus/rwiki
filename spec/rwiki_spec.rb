require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Rwiki do

  its(:configuration) { should be_instance_of(Rwiki::Configuration) }

  its('configuration.rwiki_path') { should == '/tmp/rwiki_test/fixtures' }

  its('configuration.root_page_name') { should == 'Home' }

  its('configuration.page_file_extension') { should == 'txt' }

end
