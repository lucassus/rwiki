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
      is_folder = params[:isFolder] == 'true'
      if is_folder
        new_node_name = create_folder(parent_folder_name, node_base_name)
      else
        new_node_name = create_page(parent_folder_name, node_base_name)
      end

      { :parentFolderName => parent_folder_name, :newNodeName => new_node_name }.to_json
    end

    post '/node/rename' do
      old_node_name = params[:oldNodeName]
      new_base_name = params[:newBaseName]

      success, new_node_name = rename_node(old_node_name, new_base_name)
      { :success => success,
        :oldNodeName => old_node_name,
        :newBaseName => new_base_name, :newNodeName => new_node_name }.to_json
    end

    post '/node/move' do
      node_name = params[:nodeName]
      dest_folder_name = params[:destFolderName]

      success, new_node_name = move_node(node_name, dest_folder_name)
      { :success => success, :newNodeName => new_node_name }.to_json
    end

    post '/node/destroy' do
      node_name = params[:nodeName]
      delete_node(node_name)
    end
  end
end
