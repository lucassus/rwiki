module Rwiki
  class App < Sinatra::Base
    include Models

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
      path = params[:path].strip

      folder = Folder.new(path)
      folder.nodes.to_json
    end

    get '/node' do
      path = params[:path].strip
      node = Page.new(path)

      result = { :success => true, :path => node.path,
        :raw => node.raw_content, :html => node.html_content }

      result.to_json
    end

    # update page content
    put '/node' do
      path = params[:path].strip
      raw_content = params[:rawContent]

      node = Page.new(path)
      node.raw_content = raw_content
      node.save

      { :success => true, :path => path, :raw => node.raw_content, :html => node.html_content }.to_json
    end

    # create a new node
    post '/node' do
      parent_path = params[:parentPath].strip
      name = params[:name].strip

      parent_folder = Folder.new(parent_path)
      is_folder = params[:isFolder] == 'true'
      if is_folder
        node = parent_folder.create_sub_folder(name)
      else
        node = parent_folder.create_sub_page(name)
      end

      { :success => true,
        :parentPath => parent_folder.path, :isFolder => is_folder,
        :path => node.path }.to_json
    end

    post '/node/rename' do
      path = params[:path].strip
      new_name = params[:newName].strip

      node = Node.new_from_path(path)
      node.rename(new_name)

      { :success => true, :oldPath => path, :path => node.path }.to_json
    end

    delete '/node' do
      path = params[:path].strip
      node = Node.new_from_path(path)
      node.delete

      { :success => true, :path => node.path }.to_json
    end
  end
end
