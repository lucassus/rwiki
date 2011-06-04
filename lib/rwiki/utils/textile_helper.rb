module Rwiki::Utils
  class TextileHelper

    # Regexp for extracting an article headers
    HEADER_REGEXP = /^\s*h(?<number>[1-6]?)\.\s+(?<name>.*)/.freeze

    # RedCloth for extracting code blocks
    CODE_REGEXP = /\<code( lang="(?<lang>.+?)")?\>(?<code>.+?)\<\/code\>/m.freeze

    attr_reader :content
    attr_reader :processed_content

    def initialize(content)
      @content = content.clone
      @processed_content = content.clone
    end

    def parsed_content
      process_coderay!
      process_toc!

      RedCloth.new(processed_content).to_html
    end

    def parsed_toc
      RedCloth.new(textile_toc).to_html
    end

    def textile_toc
      toc_items = []
      content.gsub(HEADER_REGEXP) do
        number = $~[:number].to_i
        name = $~[:name].strip
        anchor = sanitize_anchor_name(name)

        toc_items << ('#' * number) + %Q{ "#{name}":##{anchor}}
      end

      toc_items.join("\n")
    end

    protected

    # Execute syntax highlight for the <code> blocks
    def process_coderay!
      processed_content.gsub!(CODE_REGEXP) do
        code = ($~[:code] || '').strip
        lang = $~[:lang]
        "<notextile>#{CodeRay.scan(code, lang).html.div(:css => :class)}</notextile>"
      end
    end

    # Add anchors to the article headers
    def process_toc!
      processed_content.gsub!(HEADER_REGEXP) do
        number = $~[:number].to_i
        name = $~[:name].strip

        %Q{\nh#{number}. <a name="#{sanitize_anchor_name(name)}">#{name}</a>}
      end
    end

    def sanitize_anchor_name(name)
      name.gsub(/\s/, '-')
    end

  end
end
