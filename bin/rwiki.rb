#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rwiki'

working_folder = ARGV[0] ? File.expand_path(ARGV[0]) : Dir.pwd

RWIKI_ROOT = working_folder.freeze
p "Working folder is: #{RWIKI_ROOT}"
Dir.chdir(RWIKI_ROOT)

Rwiki::App.run!
