module Jekyll
  module Tags
    class FootnoteTag < Liquid::Tag
      include Liquid::StandardFilters

      def initialize(tag_name, text, tokens)
        super
        if text.strip =~ /^\d+$/
          @num = text.strip
        else
          raise SyntaxError.new("Unexpected arguments. #{text}")
        end
      end

      def render(context)
        "<sup><a id=\"footnote-ref-#{@num}\" href=\"#footnote-#{@num}\">[#{@num}]</a></sup>"
      end
    end
  end
end

Liquid::Template.register_tag('footnote', Jekyll::Tags::FootnoteTag)