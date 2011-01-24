module Rwiki::Models
  class Node

    PAGE_FILE_EXTENSION = '.txt'

    attr_accessor :path

    @@working_path = '.'

    class << self
      def working_path
        @@working_path
      end

      def working_path=(path)
        @@working_path = path
      end

      def fuzzy_finder(query)
        finder = FuzzyFileFinder.new(full_path_for('.'))
        matches = finder.find(query).sort_by { |m| [-m[:score], m[:path]] }
        matches.each do |m|
          m[:path] = '.' + m[:path].gsub(full_path_for('.'), '') 
        end

        return matches
      end
    end

    def self.new_from_path(path)
      full_path = File.join(working_path, path)
      klass = File.directory?(full_path) ? Folder : Page
      return klass.new(path)
    end

    def base_name
      File.basename(full_path)
    end

    def full_path
      self.class.full_path_for(@path)
    end

    def parent_folder
      Folder.new(File.dirname(@path))
    end

    def delete
      FileUtils.rm_rf(full_path)
    end

    def move(new_parent)
      new_path = File.join(new_parent.path, base_name)
      new_full_path = self.class.full_path_for(new_path)
      raise Rwiki::NodeError.new("cannot move node") if new_parent.is_a?(Page)
      raise Rwiki::NodeError.new("cannot move node") if File.exists?(new_full_path)

      FileUtils.mv(full_path, new_full_path)
      @path = new_path
    end

    def rename(new_name)
      new_path = File.join(parent_folder.path, new_name)
      new_full_path = self.class.full_path_for(new_path)
      raise Rwiki::NodeError.new("#{new_path} already exists") if File.exists?(new_full_path)

      FileUtils.mv(full_path, new_full_path)
      @path = new_path
    end

    def to_hash
      { :path => path, :baseName => base_name }
    end

    def to_json
      to_hash.to_json
    end

    private

    def initialize(path)
      @path = path
    end

    def working_path
      self.class.working_path
    end

    def self.full_path_for(path)
      File.expand_path(File.join(working_path, path))
    end

  end
end
