module Rwiki::Rake
  class Migrate

    def self.define_task
      namespace :rwiki do
        desc 'Migrate to the new rwiki structure'
        task :migrate do
          raise "unknown RWIKI_PATH" unless ENV['RWIKI_PATH']

          Rwiki.configuration.rwiki_path = File.expand_path(ENV['RWIKI_PATH'])
          puts "Rwiki path is: #{Rwiki.configuration.rwiki_path}"

          self.new
          execute!
        end
      end
    end

    def initialize
      @rwiki_path = Rwiki.configuration.rwiki_path
      @root_page_file = Rwiki.configuration.root_page_full_file_path
      @root_page_path = Rwiki.configuration.root_page_full_path
      @page_file_extension = Rwiki.configuration.page_file_extension
    end

    def execute!
      create_backup!
      create_home_page!
      update_pages!
    end

    protected

    def create_backup!
      puts 'Creating a backup...'
      FileUtils.cp_r(@rwiki_path, @rwiki_path + '.back')
    end

    def create_home_page!
      puts 'Creating the home page...'

      files = Dir.glob(@rwiki_path + '/*')

      if !File.exist?(@root_page_file)
        FileUtils.touch(@root_page_file)
      end

      if !Dir.exist?(@root_page_path)
        Dir.mkdir(@root_page_path)
        files.each do |file|
          FileUtils.mv(file, @root_page_path)
        end
      end
    end

    def update_pages!
      puts 'Updating pages...'

      Dir[@rwiki_path + '/**/*'].each do |folder|
        create_page_for_folder(folder) if File.directory?(folder)
      end
    end

    def create_page_for_folder(path)
      page_file_name = path + '.' + @page_file_extension
      if !File.exist?(page_file_name)
        puts "Creating the page '#{path + '.' + @page_file_extension}'..."
        FileUtils.touch(page_file_name)
      end
    end

  end
end
