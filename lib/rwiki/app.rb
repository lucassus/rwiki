module Rwiki
  class App < Sinatra::Base

    set :root, File.join(File.dirname(__FILE__), '../..')
    set :app_file, File.join(File.dirname(__FILE__), '../../..')

    include SmartAsset::Adapters::Sinatra
    
    disable :show_exceptions
    enable :raise_errors
    enable :logging

    configure do
      Dir.mkdir('log') unless File.exists?('log')
    end

    configure :test do
      use Rack::CommonLogger, File.new('log/test.log', 'w')
    end

    configure :development do
      use Rack::CommonLogger, File.new('log/development.log', 'w')
    end

    error NodeNotFoundError do
      message = request.env['sinatra.error'].message
      { :success => false, :message => message }.to_json
    end

    get '/' do
      erb :index
    end

    # get the node's content
    get '/node' do
      begin
        path = params[:path].strip
        page = Page.new(path)

        page.to_json
      rescue Rwiki::Page::Error => error
        { :success => false, :message => error.message }.to_json
      end
    end

    # update page content
    put '/node' do
      path = params[:path].strip
      raw_content = params[:rawContent].force_encoding("UTF-8")

      node = Page.new(path)
      node.update_file_content(raw_content)

      node.to_json
    end

    # create a new node
    post '/node' do
      parent_path = params[:parentPath].strip
      name = params[:name].strip

      parent_node = Page.new(parent_path)
      node = parent_node.add_page(name)

      node.to_json
    end

    # rename the node
    post '/node/rename' do
      path = params[:path].strip
      new_name = params[:newName].strip

      node = Page.new(path)
      node.rename_to(new_name)

      result = node.to_hash
      result[:oldPath] = path

      result.to_json
    end

    # move the node
    put '/node/move' do
      path = params[:path].strip
      new_parent_path = params[:newParentPath].strip

      node = Page.new(path)
      new_parent = Page.new(new_parent_path)

      result = node.to_hash
      result[:oldPath] = path
      result[:success] = node.move_to(new_parent)

      result.to_json
    end

    # delete the node
    delete '/node' do
      path = params[:path].strip
      node = Page.new(path)
      node.delete

      { :path => node.path }.to_json
    end

    get '/fuzzy_finder' do
      query = params[:query]
      matches = Page.fuzzy_finder(query)

      { :results => matches, :count => matches.size }.to_json
    end

    get '/node/print' do
      path = params[:path].strip
      page = Page.new(path)
      @html_content = page.html_content

      erb :print, :layout => false
    end
  end
end
