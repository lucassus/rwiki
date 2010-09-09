require 'coderay'
require 'redcloth'

module Rwiki
  module TextileUtils

    def parse_content(raw)
      raw_after_coderay = coderay(raw)
      html = RedCloth.new(raw_after_coderay).to_html

      return { :raw => raw, :html => html }
    end

    def coderay(text)
      text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
        "<notextile>#{CodeRay.scan($3, $2).div(:css => :class)}</notextile>"
      end
    end

  end
end
