require 'erb'
require 'json'
require 'sinatra'
require 'sinatra/base'

def make_tree(base_dir)
  tree = []

  Dir.entries(base_dir).each do |file_name|
    next if file_name.match(/^\./)

    full_file_name = File.join(base_dir, file_name)
    if File.directory?(full_file_name)
      tree << { :text => file_name, :cls => 'folder', :id => full_file_name }
    else
      tree << { :text => file_name, :cls => 'file', :leaf => true, :id => full_file_name }
    end
  end

  return tree
end

module Rwiki

  class App < Sinatra::Base
    set :public, File.dirname(__FILE__) + '/../public'

    get '/' do
      @time = Time.now
      erb :index
    end

    post '/nodes' do
      node = params[:node]
      node = node == 'src' ? '/home/lucassus/Projects/rwiki' : node
      make_tree(node).to_json
    end

    post '/node/content' do
      node = params[:node]
      File.read(node) { |f| f.read }.to_json
    end
  end
end
