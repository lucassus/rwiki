module Rwiki::Models
  class Node

    FILE_EXTENSION = '.txt'

    attr_accessor :path

    @@working_path = '.'

    def self.working_path=(path)
      @@working_path = path
    end

    def self.new_from_path(path)
      klass = File.directory?(path) ? Folder : Page
      return klass.new(path)
    end

    def base_name
      within_working_path do
        File.basename(@path)
      end
    end

    def delete
      within_working_path do
        FileUtils.rm_rf(@path)
      end
    end

    private

    def initialize(path)
      @path = path
    end

    def within_working_path(&block)
      self.class.within_working_path(&block)
    end

    def self.within_working_path(&block)
      Dir.chdir(@@working_path, &block)
    end

  end
end
