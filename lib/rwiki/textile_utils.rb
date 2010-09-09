require 'coderay'
require 'redcloth'

module Rwiki
  module TextileUtils

    HEADERS_REGEXP = /^\s*h([1-6])\.\s+(.*)/.freeze

    def parse_content(raw)
      raw_after_coderay = coderay(raw)
      html = parse(raw_after_coderay)
      toc = generate_toc(raw)

      return { :raw => raw, :html => toc + html }
    end

    private

    def coderay(raw)
      raw.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
        "<notextile>#{CodeRay.scan($3, $2).div(:css => :class)}</notextile>"
      end
    end

    def generate_toc(raw)
      toc = ''
    	raw.gsub(HEADERS_REGEXP) do |match|
    		level = $1.to_i
    		name = $2
    		
        header = name.gsub(/\s/, "+")
    		toc << '#' * level + ' "' + name + '":#' + header + "\n"
    	end

    	return RedCloth.new(toc).to_html
    end

    def parse(raw)
    	raw.gsub!(HEADERS_REGEXP) do |match|
    		number = $1
    		name = $2
    		header = name.gsub(/\s/, "+")
    		"\nh" + number + '. <a name="' + header + '">' + name + '</a>'
    	end

      return RedCloth.new(raw).to_html
    end

  end
end
