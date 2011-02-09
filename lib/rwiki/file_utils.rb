module Rwiki
  class FileUtils

    def self.rwiki_path
      @@rwiki_path
    end

    def self.rwiki_path=(path)
      @@rwiki_path = path
    end

    def initialize(path)
      @path = path
    end

    def exists?
      File.exists?(full_file_path)
    end

    def path
      @path
    end

    def rwiki_path
      self.class.rwiki_path
    end
    
    def file_path
      [path, Rwiki::Node::FILE_EXTENSION].join('.')
    end

    def full_path
      File.join(rwiki_path, path)
    end

    def full_file_path
      [full_path, Rwiki::Node::FILE_EXTENSION].join('.')
    end

    def base_name
      path.split('/').last
    end

    def delete
      ::FileUtils.rm_rf(full_path)
      ::FileUtils.rm_rf("#{full_path}.txt")
    end

  end
end
