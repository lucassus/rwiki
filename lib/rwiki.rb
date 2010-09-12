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
      folder_name = params[:folderName]
      make_tree(folder_name).to_json
    end

    get '/node/content' do
      page_name = params[:pageName]
      
      raw = read_file(page_name)
      parse_content(raw).to_json
    end

    post '/node/update' do
      page_name = params[:pageName]
      content = params[:content]

      write_file(page_name, content)
      parse_content(content).to_json
    end

    post '/node/create' do
      parent_folder_name = params[:parentFolderName]
      node_base_name = params[:nodeBaseName]

      new_node_name = ''
      directory = params[:isDirectory] == 'true'
      if directory
        new_node_name = create_directory(parent_folder_name, node_base_name)
      else
        new_node_name = create_page(parent_folder_name, node_base_name)
      end

      { :parentFolderName => parent_folder_name, :newNodeName => new_node_name }.to_json
    end

    post '/node/rename' do
      old_node_name = params[:oldNodeName]
      new_base_name = params[:newBaseName]

      new_node_name = rename_node(old_node_name, new_base_name)
      { :text => new_base_name, :id => new_node_name }.to_json
    end

    post '/node/move' do
      node_name = params[:nodeName]
      dest_folder_name = params[:destFolderName]

      move_node(node_name, dest_folder_name)
    end

    post '/node/destroy' do
      node_name = params[:nodeName]
      delete_node(node_name)
    end
  end
end
