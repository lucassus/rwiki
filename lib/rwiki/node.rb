module Rwiki
  class Node

    class Error < StandardError; end 

    FILE_EXTENSION = 'txt'.freeze

    class << self
      def rwiki_path
        @@rwiki_path
      end

      def rwiki_path=(path)
        @@rwiki_path = path
      end

      def sanitize_path(path)
        sanitized_path = path.clone
        sanitized_path.sub!(rwiki_path, '') if path.start_with?(rwiki_path)
        sanitized_path.gsub!(/^\//, '')
        sanitized_path.gsub!(/\/$/, '')
        sanitized_path.gsub!(/\.#{FILE_EXTENSION}$/, '')

        return sanitized_path
      end
    end

    def initialize(path)
      @path = self.class.sanitize_path(path)
      raise Rwiki::Node::Error.new("can't find the #{path} page") unless File.exists?("#{full_path}.txt")
    end

    def rwiki_path
      self.class.rwiki_path
    end

    def path
      @path
    end

    def file_path
      [path, FILE_EXTENSION].join('.')
    end

    def full_path
      File.join(rwiki_path, path)
    end

    def full_file_path
      [full_path, FILE_EXTENSION].join('.')
    end

    def base_name
      path.split('/').last
    end

    def title
      base_name
    end

    def parent
      @parent ||= Rwiki::Node.new(File.dirname(full_path))
    end

    def children
      @children ||= fetch_children
    end

    def leaf?
      children.size == 0
    end

    def has_children?
      !leaf?
    end

    def delete
      FileUtils.rm_rf(full_path)
      FileUtils.rm_rf("#{full_path}.txt")
    end

    def to_hash
      { :path => path }
    end

    protected

    def fetch_children
      children = []
      if Dir.exists?(full_path)
        files = Dir.glob("#{full_path}/*.txt").sort
        files.each do |file|
          children << Rwiki::Node.new(file)
        end
      end

      return children
    end

  end
end
