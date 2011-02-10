$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'rwiki'
require 'yaml'

config = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'config.yml'))
rwiki_path = config[:rwiki_path]

puts "Rwiki path is: #{rwiki_path}"
Rwiki.configuration.rwiki_path = rwiki_path

run Rwiki::App
