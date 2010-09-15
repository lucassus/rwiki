require 'coderay'
require 'redcloth'

module Rwiki
  module TextileUtils

    CODE_REGEXP = /\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m.freeze

    def parse_content(raw_content)
      raw_content.force_encoding('utf-8')
      
      raw_after_coderay = coderay(raw_content)
      html = parse(raw_after_coderay)
      toc = "<div class='toc-container'><div class='toc'>" + generate_toc(raw_content) + "</div></div>\n"

      return toc + html
    end

    private

    def parse(raw_content)
      raw_content = add_anchors_to_headers(raw_content)
      return RedCloth.new(raw_content).to_html
    end

    def coderay(raw_content)
      raw_content.gsub(CODE_REGEXP) do
        "<notextile>#{CodeRay.scan($3, $2).div(:css => :class)}</notextile>"
      end
    end

    def generate_raw_toc(raw_content)
      toc = ''
    	raw_content.gsub(/^\s*h([1-6])\.\s+(.*)/) do |match|
    		level = $1.to_i
    		name = $2

        header_anchor = sanitize_header_name(name)
    		toc << '#' * level + ' "' + name + '":#' + header_anchor + "\n"
    	end

      return toc
    end

    def generate_toc(raw_content)
      toc = generate_raw_toc(raw_content)
    	return RedCloth.new(toc).to_html
    end

    def add_anchors_to_headers(raw)
      return raw.gsub(/^\s*h([1-6])\.\s+(.*)/) do |match|
    		level = $1.to_i
    		name = $2

    		header_anchor = sanitize_header_name(name)
        "\nh#{level}. <a name='#{header_anchor}'>#{name}</a>"
    	end
    end

    def sanitize_header_name(name)
      return name.gsub(/\s/, "+")
    end

  end
end
