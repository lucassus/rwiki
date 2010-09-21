module Rwiki::Models
  class Folder < Node

    def initialize(path)
      raise ArgumentError unless File.exist?(path)
      raise ArgumentError unless File.directory?(path)

      super(path)
    end

    def nodes
      within_working_path do
        self.class.make_nodes(@path)
      end
    end

    def self.create(path)
      within_working_path do
        raise ArgumentError if File.exist?(path)
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
