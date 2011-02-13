module Rwiki::Utils
  class TextileHelper

    CODE_REGEXP = /\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m.freeze

    attr_reader :content

    def initialize(content)
      @content = content
    end

    def parse
      coderay!
      RedCloth.new(@content).to_html
    end

    protected

    def coderay!
      @content.gsub!(CODE_REGEXP) do
        code = ($3 || '').strip
        lang = $2
        "<notextile>#{CodeRay.scan(code, lang).html.div(:css => :class)}</notextile>"
      end
    end

  end
end
