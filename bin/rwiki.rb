#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rwiki'

working_directory = ARGV[0] || Dir.pwd
unless working_directory.start_with?('/')
  working_directory = File.join(Dir.pwd, working_directory)
end

p "Working directory: #{working_directory}"
Dir.chdir(working_directory)

Rwiki::App.run!
