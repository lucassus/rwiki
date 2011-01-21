$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'rwiki'
require 'yaml'

config = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'config.yml'))
working_path = config[:working_path]

puts "Working path is: #{working_path}"
Rwiki::Models::Node.working_path = working_path

run Rwiki::App
