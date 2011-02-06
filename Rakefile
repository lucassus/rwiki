# encoding: utf-8

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'rubygems'
require 'bundler'
require 'rwiki'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name        = "rwiki"
  gem.license     = "MIT"
  gem.summary     = %Q{Yet another personal wiki}
  gem.description = %Q{Personal wiki based on ExtJS}
  gem.email       = "lucassus@gmail.com"
  gem.homepage    = "http://github.com/lucassus/rwiki"
  gem.authors     = ["Łukasz Bandzarewicz"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version       = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "rwiki #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue cant_load_jasmine
end
