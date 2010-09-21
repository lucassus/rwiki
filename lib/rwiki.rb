require 'rubygems'
require 'erb'
require 'json/pure'
require 'sinatra'
require 'sinatra/base'

module Rwiki
  autoload :Models, 'rwiki/models'
  autoload :Utils, 'rwiki/utils'

  def self.debug
    require 'debug'
    debugger
  end

  class App < Sinatra::Base
    include Models
    include Utils

    set :root, File.dirname(__FILE__) + '/..'

    get '/' do
      erb :index
    end

    get '/nodes' do
      path = params[:path]

      folder = Folder.new(path)
      folder.nodes.to_json
    end

    get '/node' do
      begin
        path = params[:path]
        page = Page.new(path)
        result = { :success => true,
                   :path => page.path, :title => page.title,
                   :raw => page.raw_content, :html => page.html_content }
      rescue => e
        result = { :success => false, :message => e.backtrace}
      end

      result.to_json
    end

    # update page content
    put '/node' do
      begin
        path = params[:path]
        raw_content = params[:rawContent]

        page = Page.new(path)
        page.raw_content = raw_content
        page.save

        { :success => true, :path => path, :raw => page.raw_content, :html => page.html_content }.to_json
      rescue => e
        { :success => false, :message => e.backtrace }.to_json
      end
    end

    # create new node
    post '/node' do
      parent_folder_name = params[:parentFolderName]
      node_base_name = params[:nodeBaseName]

      is_folder = params[:isFolder] == 'true'
      text = node_base_name
      if is_folder
        new_node_name = create_folder(parent_folder_name, node_base_name)
      else
        node_base_name += PAGE_FILE_EXT
        new_node_name = create_page(parent_folder_name, node_base_name)
      end

      result = { :success => !!new_node_name, :text => text,
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
      begin
        path = params[:path]
        node = Node.new_from_path(path)

        success = node.delete
        { :success => success, :path => path }.to_json
      rescue => e
        { :success => false, :message => e.backtrace }
      end
    end
  end
end
