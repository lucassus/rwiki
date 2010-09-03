#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' if RUBY_VERSION < '1.9'
require 'erb'
require 'sinatra'
require 'sinatra/base'

get '/' do
  @time = Time.now
  erb :index
end

post '/nodes' do
  '[{"text":"examples","id":"\/examples","cls":"folder"},{"text":"index.html","id":"\/index.html","leaf":true,"cls":"file"},{"text":"welcome","id":"\/welcome","cls":"folder"},{"text":"ext-all.js","id":"\/ext-all.js","leaf":true,"cls":"file"},{"text":"license.txt","id":"\/license.txt","leaf":true,"cls":"file"},{"text":"ext.jsb2","id":"\/ext.jsb2","leaf":true,"cls":"file"},{"text":"src","id":"\/src","cls":"folder"},{"text":"INCLUDE_ORDER.txt","id":"\/INCLUDE_ORDER.txt","leaf":true,"cls":"file"},{"text":"docs","id":"\/docs","cls":"folder"},{"text":"test","id":"\/test","cls":"folder"},{"text":"gpl-3.0.txt","id":"\/gpl-3.0.txt","leaf":true,"cls":"file"},{"text":"adapter","id":"\/adapter","cls":"folder"},{"text":"pkgs","id":"\/pkgs","cls":"folder"},{"text":"ext-all-debug.js","id":"\/ext-all-debug.js","leaf":true,"cls":"file"},{"text":"ext-all-debug-w-comments.js","id":"\/ext-all-debug-w-comments.js","leaf":true,"cls":"file"},{"text":"resources","id":"\/resources","cls":"folder"}]'
end
