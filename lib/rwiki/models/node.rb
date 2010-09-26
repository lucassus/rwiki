module Rwiki::Models
  class Node

    PAGE_FILE_EXTENSION = '.txt'

    attr_accessor :path

    @@working_path = '.'

    class << self
      def working_path
        @@working_path
      end

      def working_path=(path)
        @@working_path = path
      end
    end

    def self.new_from_path(path)
      full_path = File.join(working_path, path)
      klass = File.directory?(full_path) ? Folder : Page
      return klass.new(path)
    end

    def base_name
      File.basename(full_path)
    end

    def full_path
      self.class.full_path_for(@path)
    end

    def parent_folder
      return Folder.new(File.dirname(@path))
    end

    def delete
      FileUtils.rm_rf(full_path)
    end

    def title
      File.basename(full_path)
    end

    private

    def initialize(path)
      @path = path
    end

    def working_path
      self.class.working_path
    end

    def self.full_path_for(path)
      File.join(working_path, path)
    end

  end
end
