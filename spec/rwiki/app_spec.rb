require File.expand_path(File.join('..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::App do
  include Rwiki
  include Rack::Test::Methods

  def app
    Rwiki::App
  end

  describe 'on GET to /' do
    before { get '/' }

    it 'should respond with success' do
      last_response.should be_ok
    end
  end

  describe 'on GET to /nodes' do
    before { get '/nodes', :path => '.' }

    it 'should respond with success' do
      last_response.should be_ok
    end
  end

  describe 'on GET to /node' do
    context 'for non-existing page' do
      before { get '/node', :path => 'Non-existing' }

      it 'should respond with error' do
        last_response.status.should == 500
      end
    end

    context 'for existing page' do
      before { get '/node', :path => 'Development/Programming Languages/Ruby' }

      it 'should respond with success' do
        last_response.should be_ok
      end
    end
  end

end
