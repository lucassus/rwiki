module Rwiki
  class FileUtils

    def initialize(path)
      @path = path
    end

    def exists?
      File.exists?(full_file_path)
    end

    def path
      @path
    end

    def file_path
      [path, Rwiki::Node::FILE_EXTENSION].join('.')
    end

    def full_path
      File.join(Rwiki.configuration.rwiki_path, path)
    end

    def full_file_path
      [full_path, Rwiki::Node::FILE_EXTENSION].join('.')
    end

    def full_parent_path
      File.dirname(full_path)
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
