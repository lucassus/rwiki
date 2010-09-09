require 'erb'
require 'json'
require 'sinatra'
require 'sinatra/base'

module Rwiki
  autoload :FileUtils, 'rwiki/file_utils'
  autoload :TextileUtils, 'rwiki/textile_utils'

  class App < Sinatra::Base
    include FileUtils
    include TextileUtils

    set :root, File.dirname(__FILE__) + '/..'

    get '/' do
      erb :index
    end

    post '/nodes' do
      node = params[:node]
      node = node == 'root-dir' ? '.' : node

      make_tree(node).to_json
    end

    get '/node/content' do
      node = params[:node]
      
      raw = read_file(node)
      parse_content(raw).to_json
    end

    post '/node/update' do
      node = params[:node]
      content = params[:content]

      raw = write_file(node, content)
      parse_content(raw).to_json
    end

    post '/node/create' do
      node = params[:node]
      name = params[:name]
      directory = params[:directory] == 'true'

      if directory
        create_directory(node, name)
      else
        create_file(node, name)
      end

      { :success => true }.to_json
    end

    post '/node/destroy' do
      node = params[:node]
      delete_node(node)
      
      { :success => true }.to_json
    end
  end
end
