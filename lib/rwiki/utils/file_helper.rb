module Rwiki::Utils
  class FileHelper

    attr_reader :path

    def initialize(path)
      @path = path
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

    def exists?
      File.exists?(full_file_path)
    end

    def read_file_content
      File.open(full_file_path, 'r:UTF-8') { |f| f.read }
    end

    def create_subpage(name)
      new_file_full_path = File.join(full_path, name)
      new_file_full_path += '.txt' unless name.end_with?(".#{Rwiki.configuration.page_file_extension}")

      FileUtils.mkdir_p(full_path) unless Dir.exists?(full_path)
      File.open(new_file_full_path, 'w') { |f| f.write("h1. #{name}\n\n") }
      new_file_full_path
    end

    def delete
      FileUtils.rm_rf(full_path)
      FileUtils.rm_rf("#{full_path}.txt")
    end

    def rename(new_name)
      new_name.gsub!(/\.#{Rwiki.configuration.page_file_extension}$/, '')
      new_full_path = File.join(full_parent_path, new_name)

      unless File.exists?(new_full_path)
        FileUtils.mv(full_path, new_full_path)
        FileUtils.mv(full_file_path, "#{new_full_path}.#{Rwiki.configuration.page_file_extension}")

        @path = self.class.sanitize_path(new_full_path)
        true
      else
        false
      end
    end

    def self.sanitize_path(path)
      sanitized_path = path.clone

      sanitized_path.sub!(Rwiki.configuration.rwiki_path, '') if path.start_with?(Rwiki.configuration.rwiki_path)
      sanitized_path.gsub!(/^\//, '')
      sanitized_path.gsub!(/\/$/, '')
      sanitized_path.gsub!(/\.#{Rwiki.configuration.page_file_extension}$/, '')

      sanitized_path
    end
    
  end
end
