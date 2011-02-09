module Rwiki::Models
  class Page < Node

    CODE_REGEXP = /\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m.freeze

    def initialize(path)
      full_path = self.class.full_path_for(path)
      raise Rwiki::NodeNotFoundError.new("cannot find #{path}") if !File.exist?(full_path) || !File.file?(full_path)
      raise Rwiki::NodeNotFoundError.new("#{path} has illegal name") unless path.end_with?(PAGE_FILE_EXTENSION)

      super(path)
    end

    def raw_content
      @raw_content ||= read_file
    end
    alias :to_textile :raw_content

    def raw_content=(raw)
      @raw_content = raw
      @html_content = nil
    end

    def html_content
      @html_content ||= parse_content
    end
    
    alias :to_html :html_content

    def title
      base_name.gsub(/#{PAGE_FILE_EXTENSION}$/, '')
    end

    def rename(new_name)
      new_name = new_name + PAGE_FILE_EXTENSION unless new_name.end_with?(PAGE_FILE_EXTENSION)
      super(new_name)
    end

    def reload!
      @raw_content = nil
      @html_content = nil
    end

    def save
      File.open(full_path, 'w:UTF-8') { |f| f.write(@raw_content) }
    end

    def to_hash
      super.merge({ :rawContent => to_textile, :htmlContent => to_html })
    end

    private

    def read_file
      File.open(full_path, 'r:UTF-8') { |f| f.read }
    end

    def parse_content
      coderay!

#      toc = generate_toc
#      add_anchors_to_headers!
      
#      return toc + RedCloth.new(raw_content).to_html
      RedCloth.new(raw_content).to_html
    end

    def coderay!
      @raw_content = raw_content.gsub(CODE_REGEXP) do
        code = ($3 || '').strip
        lang = $2
        "<notextile>#{CodeRay.scan(code, lang).html.div(:css => :class)}</notextile>"
      end
    end

    def generate_raw_toc
      toc = ''
      raw_content.gsub(/^\s*h([1-6])\.\s+(.*)/) do
        level = $1.to_i
        name = $2

        header_anchor = sanitize_header_name(name)
        toc << '#' * level + ' "' + name + '":#' + header_anchor + "\n"
      end

      toc
    end

    def generate_toc
      raw_toc = generate_raw_toc
      toc = RedCloth.new(raw_toc).to_html
      toc = '<div class="toc-container"><div class="toc">' + toc + '</div></div>' unless toc == ''
      toc
    end

    def add_anchors_to_headers!
      self.raw_content = raw_content.gsub(/^\s*h([1-6])\.\s+(.*)/) do
        level = $1.to_i
        name = $2

        header_anchor = sanitize_header_name(name)
        "\nh#{level}. <a name=\"#{header_anchor}\">#{name}</a>"
      end
    end

    def sanitize_header_name(name)
      name.gsub(/\s/, "+")
    end

  end
end
