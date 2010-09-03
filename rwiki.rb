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
