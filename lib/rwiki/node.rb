module Rwiki
  class Node
    include Rwiki::Utils

    class Error < StandardError; end 

    attr_reader :path
    attr_reader :file_helper

    def initialize(path)
      @path = FileHelper.sanitize_path(path)
      @file_helper = FileHelper.new(@path)
      raise Error.new("can't find the #{path} page") unless @file_helper.exists?
    end

    def full_path
      @file_helper.full_path
    end

    def title
      path.split('/').last
    end

    def parent
      @parent ||= Node.new(@file_helper.full_parent_path)
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
      Node.new(@file_helper.create_subpage(name))
    end

    def file_content
      @file_content ||= @file_helper.read_file_content
    end

    def html_content
      @html_content ||= RedCloth.new(file_content).to_html
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
          tree_node[:children] = tree(child.file_helper.full_path)
        end

        result << tree_node
      end

      result
    end

    protected

    def fetch_children
      self.class.fetch_children(full_path)
    end

    def self.fetch_children(full_path)
      children = []

      if Dir.exists?(full_path)
        files = Dir.glob("#{full_path}/*.txt").sort
        files.each do |file|
          children << Node.new(file)
        end
      end

      children
    end

  end
end
