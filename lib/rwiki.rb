require 'erb'
require 'json'
require 'sinatra'
require 'sinatra/base'

require 'rwiki/file_utils'

module Rwiki
  class App < Sinatra::Base
    include FileUtils

    set :public, File.dirname(__FILE__) + '/../public'

    get '/' do
      @time = Time.now
      erb :index
    end

    post '/nodes' do
      dir = params[:node]
      dir = dir == 'src' ? '/' : decode_file_name(dir)
      make_tree(dir).to_json
    end

    get '/node/content' do
      file_name = decode_file_name(params[:node]) + '.txt'
      read_file(file_name).to_json
    end

    post '/node/update' do
      file_name = decode_file_name(params[:node]) + '.txt'
      content = params[:content]

      write_file(file_name, content).to_json
    end
  end
end
