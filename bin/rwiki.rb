#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rwiki'

root_path = Dir.pwd
root_path = File.join(root_path, ARGV[0]) if ARGV[0]
ROOT_PATH = root_path

p "Working directory: #{root_path}"

Rwiki::App.run!
