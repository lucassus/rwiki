require 'erb'
require 'json'
require 'sinatra'
require 'sinatra/base'

module Rwiki
  autoload :FileUtils, 'rwiki/file_utils'

  class App < Sinatra::Base
    include FileUtils

    set :public, File.dirname(__FILE__) + '/../public'

    get '/' do
      @time = Time.now
      erb :index
    end

    post '/nodes' do
      node_id = params[:node]
      dir = node_id == 'src-dir' ? '/' : decode_directory_name(node_id)
      make_tree(dir).to_json
    end

    get '/node/content' do
      node_id = params[:node]
      file_name = decode_file_name(node_id)
      read_file(file_name).to_json
    end

    post '/node/update' do
      node_id = params[:node]
      file_name = decode_file_name(node_id)
      content = params[:content]

      write_file(file_name, content).to_json
    end

    post '/node/create' do
      node_id = params[:node]
      parent_directory = decode_directory_name(node_id)

      name = params[:name]
      directory = params[:directory] == 'true'

      if directory
        create_directory(parent_directory, name)
      else
        create_file(parent_directory, name)
      end

      {:success => true}.to_json
    end

    post '/node/destroy' do
      node_id = params[:node]
      path = decode_node_name(node_id)
      delete_node(path)
      
      {:success => true}.to_json
    end
  end
end
