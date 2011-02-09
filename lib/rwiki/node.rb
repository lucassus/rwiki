module Rwiki
  class Node

    class Error < StandardError; end 

    FILE_EXTENSION = 'txt'.freeze

    attr_reader :path
    attr_reader :file_utils

    def initialize(path)
      @path = self.class.sanitize_path(path)
      @file_utils = Rwiki::FileUtils.new(@path)
      raise Rwiki::Node::Error.new("can't find the #{path} page") unless @file_utils.exists?
    end

    def title
      @file_utils.base_name
    end

    def parent
      @parent ||= Rwiki::Node.new(@file_utils.full_parent_path)
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
      @file_utils.delete
    end

    def to_hash
      { :path => path }
    end

    alias :to_extjs_hash :to_hash

    class << self
      def sanitize_path(path)
        sanitized_path = path.clone
        
        sanitized_path.sub!(Rwiki.configuration.rwiki_path, '') if path.start_with?(Rwiki.configuration.rwiki_path)
        sanitized_path.gsub!(/^\//, '')
        sanitized_path.gsub!(/\/$/, '')
        sanitized_path.gsub!(/\.#{FILE_EXTENSION}$/, '')

        return sanitized_path
      end

      def fetch_children(full_path)
        children = []
        if Dir.exists?(full_path)
          files = Dir.glob("#{full_path}/*.txt").sort
          files.each do |file|
            children << Rwiki::Node.new(file)
          end
        end

        return children
      end

      def tree(path = Rwiki.configuration.rwiki_path)
        children = fetch_children(path)
        result = children.map { |n| n.to_extjs_hash }

        i = 0
        result.each do |tree_node|
          child = children[i]
          if child.has_children?
            tree_node[:children] = tree(child.file_utils.full_path)
          end

          i += 1
        end

        return result
      end
    end

    protected

    def fetch_children
      self.class.fetch_children(@file_utils.full_path)
    end

  end
end
