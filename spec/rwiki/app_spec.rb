require File.expand_path(File.join('..', 'spec_helper'), File.dirname(__FILE__))

describe Rwiki::App do
  include Rwiki
  include Rack::Test::Methods

  def app
    @app ||= Rwiki::App
  end
  subject { app }

  its(:environment) { should == :test }

  describe 'on GET to /' do
    before { get '/' }
    it_should_respond_with_success
  end

  describe 'on GET to /node' do
    context 'for non-existing page' do
      before { get '/node', :path => 'Non-existing' }
      it_should_respond_with_success
    end

    context 'for existing page' do
      before { get '/node', :path => '/Home/Development/Programming Languages/Ruby' }
      it_should_respond_with_success
    end
  end

  describe 'on PUT to /node' do
    before { put '/node', :path => '/Home/Development', :rawContent => 'h1. The new page content' }
    it_should_respond_with_success
  end

  describe 'on POST to /rename' do
    before { post '/node/rename', :path => '/Home/Development', :newName => 'Nerd stuff' }
    it_should_respond_with_success
  end

  describe 'on PUT to /node/move' do
    before { put '/node/move', :newParentPath => '/Home/Personal stuff', :path => '/Home/Development' }
    it_should_respond_with_success
  end

  describe 'on DELETE to /node' do
    before { delete '/node', :path => '/Home/Development' }
    it_should_respond_with_success
  end

  describe 'on GET to /fuzzy_finder' do
    before { get '/fuzzy_finder', :query => 'Ruby' }
    it_should_respond_with_success
  end

  describe 'on GET to /text_search' do
    before { get '/text_search', :query => 'Ruby' }
    it_should_respond_with_success
  end

  describe 'on GET to /node/print' do
    before { get '/node/print', :path => '/Home/About' }
    it_should_respond_with_success
  end

end
