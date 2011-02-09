module Rwiki
  class FileUtils

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def exists?
      File.exists?(full_file_path)
    end

    def file_path
      [path, Rwiki.configuration.page_file_extension].join('.')
    end

    def full_path
      File.join(Rwiki.configuration.rwiki_path, path)
    end

    def full_file_path
      [full_path, Rwiki.configuration.page_file_extension].join('.')
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

    def self.sanitize_path(path)
      sanitized_path = path.clone

      sanitized_path.sub!(Rwiki.configuration.rwiki_path, '') if path.start_with?(Rwiki.configuration.rwiki_path)
      sanitized_path.gsub!(/^\//, '')
      sanitized_path.gsub!(/\/$/, '')
      sanitized_path.gsub!(/\.#{Rwiki.configuration.page_file_extension}$/, '')

      return sanitized_path
    end
    
  end
end
