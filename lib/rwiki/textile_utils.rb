require 'coderay'
require 'redcloth'

module Rwiki
  module TextileUtils

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
      headreg = /^\s*h([1-6])\.\s+(.*)/

      toc = ''
    	raw.gsub(headreg) do |match|
    		level = $1.to_i
    		name = $2
    		
        header = name.gsub(/\s/, "+")
    		toc << '#' * level + ' "' + name + '":#' + header + "\n"
    	end

    	return RedCloth.new(toc).to_html
    end

    def parse(raw)
      headreg = /^\s*h([1-6])\.\s+(.*)/

    	raw.gsub!(headreg) do |match|
    		number = $1
    		name = $2
    		header = name.gsub(/\s/, "+")
    		"\nh" + number + '. <a name="' + header + '">' + name + '</a>'
    	end

      return RedCloth.new(raw).to_html
    end

  end
end
