module Rwiki::Models
  class Folder < Node

    def initialize(path)
      full_path = File.join(@@working_path, path)
      raise Rwiki::NodeNotFoundError.new("cannot find #{path}") if !File.exist?(full_path) || ! File.directory?(full_path)
      super(path)
    end

    def nodes
      Dir.chdir(working_path) do
        self.class.make_nodes(@path)
      end
    end

    def create_sub_folder(name)
      new_folder_path = File.join(@path, name)
      new_folder_full_path = self.class.full_path_for(new_folder_path)
      raise Rwiki::NodeError.new("#{new_folder_path} already exists") if File.exists?(new_folder_full_path)

      FileUtils.mkdir(new_folder_full_path)
      return Folder.new(new_folder_path)
    end

    def create_sub_page(name)
      name = name + '.txt' unless name.end_with?('.txt')
      new_page_path = File.join(@path, name)
      new_page_full_path = self.class.full_path_for(new_page_path)
      raise Rwiki::NodeError.new("#{new_page_path} already exists") if File.exists?(new_page_full_path)

      FileUtils.touch(new_page_full_path)
      return Page.new(new_page_path)
    end

    private

    def self.make_nodes(root_path)
      tree_nodes = []

      nodes = Dir.entries(root_path).sort
      nodes.each do |node_base_name|
        next if node_base_name.match(/^\./) # skip hidden files

        path = File.join(root_path, node_base_name)
        tree_node = { :id => node_base_name }

        if File.directory?(path)
          children = make_nodes(path)
          tree_nodes << tree_node.merge(:text => node_base_name,
            :cls => 'folder', :children => children)
        else
          next unless node_base_name.match(/#{PAGE_FILE_EXTENSION}$/)
          tree_nodes << tree_node.merge(:text => node_base_name.gsub(/#{PAGE_FILE_EXTENSION}$/, ''),
            :cls => 'page', :leaf => true)
        end
      end

      return tree_nodes
    end

  end
end
