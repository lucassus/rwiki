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

    get '/nodes' do
      directory_name = params[:directoryName]
      make_tree(directory_name).to_json
    end

    get '/node/content' do
      file_name = params[:fileName]
      
      raw = read_file(file_name)
      parse_content(raw).to_json
    end

    post '/node/update' do
      file_name = params[:fileName]
      content = params[:content]

      raw = write_file(file_name, content)
      parse_content(raw).to_json
    end

    post '/node/create' do
      parent_directory_name = params[:parentDirectoryName]
      node_base_name = params[:nodeBaseName]

      new_node_name = ''
      directory = params[:isDirectory] == 'true'
      if directory
        new_node_name = create_directory(parent_directory_name, node_base_name)
      else
        new_node_name = create_page(parent_directory_name, node_base_name)
      end

      { :parentDirectoryName => parent_directory_name, :newNodeName => new_node_name }.to_json
    end

    post '/node/rename' do
      old_node_name = params[:oldNodeName]
      new_base_name = params[:newBaseName]

      new_node_name = rename_node(old_node_name, new_base_name)
      { :text => new_base_name, :id => new_node_name }.to_json
    end

    post '/node/move' do
      node_name = params[:nodeName]
      dest_dir_name = params[:destDirName]

      move_node(node_name, dest_dir_name)
    end

    post '/node/destroy' do
      node_name = params[:nodeName]
      delete_node(node_name)
    end
  end
end
