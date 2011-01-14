# encoding: utf-8

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rwiki"
    gem.summary = %Q{Yet another personal wiki}
    gem.description = %Q{Personal wiki based on ExtJS}
    gem.email = "lucassus@gmail.com"
    gem.homepage = "http://github.com/lucassus/rwiki"
    gem.authors = ["Łukasz Bandzarewicz"]

    gem.add_dependency "sinatra"
    gem.add_dependency "RedCloth"
    gem.add_dependency "coderay"
    gem.add_dependency "json_pure"
    gem.add_dependency "thin"

    if RUBY_VERSION >= "1.9"
      gem.add_development_dependency "ruby-debug19"
    else
      gem.add_development_dependency "ruby-debug"
    end

    gem.add_development_dependency "rack-test"
    gem.add_development_dependency "test-unit"
    gem.add_development_dependency "shoulda"
    gem.add_development_dependency "jasmine"

    gem.add_development_dependency "cucumber"
    gem.add_development_dependency "capybara"
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "rspec-core"
    gem.add_development_dependency "rspec-expectations"

    gem.add_development_dependency "Selenium"
    gem.add_development_dependency "selenium-client"

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rwiki #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  puts "Jasmine not available. Install it with: gem install jasmine"
end
