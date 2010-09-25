module Rwiki
  class App < Sinatra::Base
    include Models
    include Utils

    set :raise_errors, false
    set :show_exceptions, false
    set :root, File.join(File.dirname(__FILE__), '../..')

    error NodeNotFoundError do
      message = request.env['sinatra.error'].message
      { :success => false, :message => message }.to_json
    end

    get '/' do
      erb :index
    end

    get '/nodes' do
      path = params[:path]

      folder = Folder.new(path)
      folder.nodes.to_json
    end

    get '/node' do
      path = params[:path]
      page = Page.new(path)

      result = { :success => true,
        :path => page.path, :title => page.title,
        :raw => page.raw_content, :html => page.html_content }

      result.to_json
    end

    # update page content
    put '/node' do
      path = params[:path]
      raw_content = params[:rawContent]

      page = Page.new(path)
      page.raw_content = raw_content
      page.save

      { :success => true, :path => path, :raw => page.raw_content, :html => page.html_content }.to_json
    end

    # create a new node
    post '/node' do
      parent_path = params[:parentPath]
      name = params[:name]

      parent_folder = Folder.new(parent_path)
      is_folder = params[:isFolder] == 'true'
      if is_folder
        node = parent_folder.create_sub_folder(name)
      else
        node = parent_folder.create_sub_page(name)
      end

      result = { :success => true, :text => name,
        :parentPath => parent_folder.path, :isFolder => is_folder,
        :path => node.path }

      result.to_json
    end

    post '/node/rename' do
      path = params[:path]
      new_name = params[:newName]

      page = Page.new(path)
      page.rename(new_name)

      { :success => true, :path => page.path, :text => page.title }.to_json
    end

    #    post '/node/move' do
    #      node_name = params[:nodeName]
    #      dest_folder_name = params[:destFolderName]
    #
    #      success, new_node_name = move_node(node_name, dest_folder_name)
    #      { :success => success, :newNodeName => new_node_name }.to_json
    #    end

    delete '/node' do
      path = params[:path]
      node = Node.new_from_path(path)
      node.delete

      { :success => true, :path => node.path }.to_json
    end
  end
end
