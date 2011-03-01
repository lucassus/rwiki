module Rwiki::Utils
  class TextileHelper

    CODE_REGEXP = /\<code( lang="(?<lang>.+?)")?\>(?<code>.+?)\<\/code\>/m.freeze

    attr_reader :content

    def initialize(content)
      @content = content
    end

    def parse
      content_after_coderay = self.class.coderay(content)
      RedCloth.new(content_after_coderay).to_html
    end

    protected

    def self.coderay(content)
      content.gsub(CODE_REGEXP) do
        code = ($~[:code] || '').strip
        lang = $~[:lang]
        "<notextile>#{CodeRay.scan(code, lang).html.div(:css => :class)}</notextile>"
      end
    end

  end
end
