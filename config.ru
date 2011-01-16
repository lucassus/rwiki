$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'rwiki'

working_path = (ARGV[0] ? File.expand_path(ARGV[0]) : Dir.pwd).freeze
puts "Working path is: #{working_path}"
Rwiki::Models::Node.working_path = working_path

Rwiki::App.run!
