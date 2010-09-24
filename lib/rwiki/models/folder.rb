module Rwiki::Models
  class Folder < Node

    def initialize(path)
      within_working_path do
        raise Rwiki::FolderNotFoundError.new("cannot find #{path}") if !File.exist?(path) || ! File.directory?(path)
        super(path)
      end
    end

    def nodes
      within_working_path do
        self.class.make_nodes(@path)
      end
    end

    def create_sub_folder(name)
      new_folder_path = File.join(@path, name)
      raise Rwiki::FolderError.new("#{new_folder_path} already exists") if File.exists?(new_folder_path)

      within_working_path do
        FileUtils.mkdir(new_folder_path)
      end
      
      return Folder.new(new_folder_path)
    end

    def create_sub_page(name)
      name = name + '.txt' unless name.end_with?('.txt')
      new_page_path = File.join(@path, name)
      raise Rwiki::PageError.new("#{new_page_path} already exists") if File.exists?(new_page_path)

      within_working_path do
        FileUtils.touch(new_page_path)
      end
      
      return Page.new(new_page_path)
    end

    def self.create(path)
      raise Rwiki::FolderError.new("#{path} already exists") if File.exist?(path)

      within_working_path do
        FileUtils.mkdir(path)
      end

      return Folder.new(path)
    end

    private

    def self.make_nodes(root_path)
      tree_nodes = []

      nodes = Dir.entries(root_path).sort
      nodes.each do |node_base_name|
        next if node_base_name.match(/^\./) # skip hidden files

        path = File.join(root_path, node_base_name)
        tree_node = {:id => path}

        if File.directory?(path)
          children = make_nodes(path)
          tree_nodes << tree_node.merge(:text => node_base_name,
            :cls => 'folder', :children => children)
        else
          next unless node_base_name.match(/#{FILE_EXTENSION}$/)
          tree_nodes << tree_node.merge(:text => node_base_name.gsub(/#{FILE_EXTENSION}$/, ''),
            :cls => 'page', :leaf => true)
        end
      end

      return tree_nodes
    end

  end
end
