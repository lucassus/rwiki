require File.expand_path(File.dirname(__FILE__) + '../../helper')
require 'cgi'

class Rwiki::TestApp < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Rwiki::App
  end

  context 'on GET to /' do
    setup { get '/' }

    should 'respond with success' do
      assert last_response.ok?
    end
  end

  context 'on GET to /nodes' do
    setup { get '/nodes', :path => '.' }

    should 'respond with success' do
      assert last_response.ok?
    end
  end

  context 'on GET to /node' do
    context 'for non-existing page' do
      setup { get '/node', :path => './non-existing.txt' }

      should 'respond with error' do
        assert_equal 500, last_response.status
      end
    end

    context 'for existing page' do
      setup { get '/node', :path => './home.txt' }

      should 'respond with success' do
        assert last_response.ok?
      end
    end
  end

end
