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
      tree = make_tree(folder_name)
      tree.to_json
    end

    get '/node/content' do
      page_name = params[:pageName]
      raw_content = read_page(page_name)

      result = { :pageName => page_name }
      unless raw_content.nil?
        html = parse_content(raw_content)

        result[:success] = true
        result[:raw] = raw_content
        result[:html] = html
      else
        result[:success] = false
      end

      result.to_json
    end

    post '/node/update' do
      page_name = params[:pageName]
      raw_content = params[:content]

      success = write_page(page_name, raw_content)
      result = { :success => success, :pageName => page_name, :raw => raw_content }
      result[:html] = parse_content(raw_content) if success

      result.to_json
    end

    post '/node/create' do
      parent_folder_name = params[:parentFolderName]
      node_base_name = params[:nodeBaseName]

      is_folder = params[:isFolder] == 'true'
      if is_folder
        new_node_name = create_folder(parent_folder_name, node_base_name)
      else
        node_base_name += PAGE_FILE_EXT
        new_node_name = create_page(parent_folder_name, node_base_name)
      end

      result = { :success => !!new_node_name,
        :parentFolderName => parent_folder_name, :isFolder => is_folder,
        :newNodeName => new_node_name, :newNodeBaseName => node_base_name }

      result.to_json
    end

    post '/node/rename' do
      old_node_name = params[:oldNodeName]
      new_base_name = params[:newBaseName]

      success, new_node_name = rename_node(old_node_name, new_base_name)
      { :success => success,
        :oldNodeName => old_node_name,
        :newNodeName => new_node_name, :newBaseName => new_base_name }.to_json
    end

    post '/node/move' do
      node_name = params[:nodeName]
      dest_folder_name = params[:destFolderName]

      success, new_node_name = move_node(node_name, dest_folder_name)
      { :success => success, :newNodeName => new_node_name }.to_json
    end

    post '/node/destroy' do
      node_name = params[:nodeName]
      success = delete_node(node_name)
      { :success => success, :nodeName => node_name }.to_json
    end
  end
end
