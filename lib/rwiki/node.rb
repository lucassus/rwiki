module Rwiki
  class Node

    class Error < StandardError; end 

    attr_reader :path
    attr_reader :file_utils

    def initialize(path)
      @path = Rwiki::FileUtils.sanitize_path(path)
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

    def create_subpage(name)
      Rwiki::Node.new(@file_utils.create_subpage(name))
    end

    def delete
      @file_utils.delete
    end

    def to_hash
      {
        :path => path,
        :text => title,
        :leaf => leaf?,
        :cls => leaf? ? 'page' : 'folder'
      }
    end

    def self.tree(full_path = Rwiki.configuration.rwiki_path)
      result = []
      children = fetch_children(full_path)

      children.each do |child|
        tree_node = child.to_hash

        if child.has_children?
          tree_node[:children] = tree(child.file_utils.full_path)
        end

        result << tree_node
      end

      result
    end

    protected

    def fetch_children
      self.class.fetch_children(@file_utils.full_path)
    end

    def self.fetch_children(full_path)
      children = []

      if Dir.exists?(full_path)
        files = Dir.glob("#{full_path}/*.txt").sort
        files.each do |file|
          children << Rwiki::Node.new(file)
        end
      end

      children
    end

  end
end
