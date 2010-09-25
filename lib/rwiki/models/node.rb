module Rwiki::Models
  class Node

    FILE_EXTENSION = '.txt'

    attr_accessor :path

    @@working_path = '.'

    def self.working_path=(path)
      @@working_path = path
    end

    def self.new_from_path(path)
      full_path = File.join(@@working_path, path)
      klass = File.directory?(full_path) ? Folder : Page
      return klass.new(path)
    end

    def base_name
      File.basename(full_path)
    end

    def delete
      FileUtils.rm_rf(full_path)
    end

    private

    def initialize(path)
      @path = path
    end

    def self.full_path_for(path)
      File.join(@@working_path, path)
    end

    def full_path
      self.class.full_path_for(@path)
    end

  end
end
