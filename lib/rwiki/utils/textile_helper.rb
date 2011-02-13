module Rwiki::Utils
  class TextileHelper

    attr_reader :content

    def initialize(content)
      @content = content
    end

    def parse
      RedCloth.new(@content).to_html
    end

  end
end
