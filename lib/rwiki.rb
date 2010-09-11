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
      name = params[:name]

      directory = params[:directory] == 'true'
      if directory
        create_directory(parent_directory_name, name)
      else
        create_page(parent_directory_name, name)
      end

      { :success => true }.to_json
    end

    post '/node/rename' do
      # TODO give better names, old_name is with full relative path, new_name is only a file name
      old_name = params[:oldName]
      new_name = params[:newName]

      new_name = rename_node(old_name, new_name)
      { :text => new_name, :id => File.join(Dir.pwd, new_name) }.to_json
    end

    post '/node/move' do
      file_name = params[:fileName]
      dest_dir = params[:destDir]

      move_node(file_name, dest_dir)
    end

    post '/node/destroy' do
      file_name = params[:fileName]
      delete_node(file_name)
      
      { :success => true }.to_json
    end
  end
end
