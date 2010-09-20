#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rwiki'

working_folder = ARGV[0] || Dir.pwd
unless working_folder.start_with?('/')
  working_folder = File.join(Dir.pwd, working_folder)
end

RWIKI_ROOT = working_folder.freeze
p "Working folder is: #{RWIKI_ROOT}"
Dir.chdir(RWIKI_ROOT)

Rwiki::App.run!
