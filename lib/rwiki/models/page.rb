require 'coderay'
require 'redcloth'

module Rwiki::Models
  class Page < Node

    CODE_REGEXP = /\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m.freeze

    def initialize(path)
      within_working_path do
        raise Rwiki::PageNotFoundError.new("cannot find #{path}") if !File.exist?(path) || !File.file?(path)
        raise Rwiki::PageNotFoundError.new("#{path} has illegal name") unless path.end_with?(FILE_EXTENSION)
        super(path)
      end
    end

    def raw_content
      @raw_content ||= read_file
    end

    def raw_content=(raw)
      @raw_content = raw
      @html_content = nil
    end

    def html_content
      @html_content ||= parse_content
    end

    def title
      File.basename(@path).gsub(/#{FILE_EXTENSION}$/, '')
    end

    def save
      within_working_path do
        file = File.open(@path, 'w')
        file.write(@raw_content)
        file.close
      end
    end

    private

    def read_file
      within_working_path do
        File.read(@path) { |f| f.read }
      end
    end

    def parse_content
      coderay
      return RedCloth.new(raw_toc + raw_content).to_html
    end

    def coderay
      @raw_content = raw_content.gsub(CODE_REGEXP) do
        "<notextile>#{CodeRay.scan($3, $2).div(:css => :class)}</notextile>"
      end
    end

    def generate_raw_toc
      toc = ''
      raw_content.gsub(/^\s*h([1-6])\.\s+(.*)/) do |match|
        level = $1.to_i
        name = $2

        header_anchor = sanitize_header_name(name)
        toc << '#' * level + ' "' + name + '":#' + header_anchor + "\n"
      end

      return toc
    end

    def generate_toc
      toc = generate_raw_toc(raw_content)
      return RedCloth.new(toc).to_html
    end

    def add_anchors_to_headers
      @raw_content = raw_content.gsub(/^\s*h([1-6])\.\s+(.*)/) do |match|
        level = $1.to_i
        name = $2

        header_anchor = sanitize_header_name(name)
        "\nh#{level}. <a name=\"#{header_anchor}\">#{name}</a>"
      end
    end

    def sanitize_header_name(name)
      return name.gsub(/\s/, "+")
    end

  end
end
