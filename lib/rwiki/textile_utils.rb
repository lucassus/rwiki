require 'coderay'
require 'redcloth'

module Rwiki
  module TextileUtils

    HEADERS_REGEXP = /^\s*h([1-6])\.\s+(.*)/.freeze
    CODE_REGEXP = /\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m.freeze

    def parse_content(raw)
      raw.force_encoding('utf-8')
      raw_after_coderay = coderay(raw)
      html = parse(raw_after_coderay)
      toc = "<div class='toc'>" + generate_toc(raw) + "</div>"

      return { :raw => raw, :html => toc + html }
    end

    private

    def coderay(raw)
      raw.gsub(CODE_REGEXP) do
        "<notextile>#{CodeRay.scan($3, $2).div(:css => :class)}</notextile>"
      end
    end

    def generate_toc(raw)
      toc = ''
    	raw.gsub(HEADERS_REGEXP) do |match|
    		level = $1.to_i
    		name = $2
    		
        header_anchor = sanitize_header_name(name)
    		toc << '*' * level + ' "' + name + '":#' + header_anchor + "\n"
    	end

    	return RedCloth.new(toc).to_html
    end

    def parse(raw)
      raw = add_anchors_to_headers(raw)
      return RedCloth.new(raw).to_html
    end

    def add_anchors_to_headers(raw)
      return raw.gsub(HEADERS_REGEXP) do |match|
    		level = $1.to_i
    		name = $2

    		header_anchor = sanitize_header_name(name)
        "h#{level}. <a name='#{header_anchor}'>#{name}</a>\n"
    	end
    end

    def sanitize_header_name(name)
      return name.gsub(/\s/, "+")
    end

  end
end
