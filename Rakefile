# encoding: utf-8

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "cucumber/rake/task"
require "rspec/core/rake_task"
require "rspec/core/version"
require 'ci/reporter/rake/rspec'

require 'rwiki'

task :default => :spec

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_path = 'rspec'
  t.rspec_opts = %w[--color]
  t.verbose = false
end

Cucumber::Rake::Task.new(:cucumber)

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name        = "rwiki"
  gem.license     = "GPLv3"
  gem.summary     = %{Personal wiki based on ExtJS}
  gem.description = %{Personal wiki based on ExtJS}
  gem.email       = "lucassus@gmail.com"
  gem.homepage    = "http://github.com/lucassus/rwiki"
  gem.authors     = ["Łukasz Bandzarewicz"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

require 'jasmine'
load 'jasmine/tasks/jasmine.rake'
