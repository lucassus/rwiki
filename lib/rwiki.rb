require 'erb'
require 'json'
require 'sinatra'
require 'sinatra/base'

require 'rwiki/file_utils'

module Rwiki
  ROOT_PATH = File.dirname(__FILE__) + '/../test/fixtures/pages'

  class App < Sinatra::Base
    include FileUtils

    set :public, File.dirname(__FILE__) + '/../public'

    get '/' do
      @time = Time.now
      erb :index
    end

    post '/nodes' do
      node = params[:node]
      node = node == 'src' ? ROOT_PATH : node
      make_tree(node).to_json
    end

    post '/node/content' do
      node = params[:node]
      read_file(node).to_json
    end
  end
end
