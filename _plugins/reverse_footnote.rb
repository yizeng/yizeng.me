module Jekyll
  module Tags
    class ReverseFootnoteTag < Liquid::Tag
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
        "<a class=\"reverse-footnote internal\" data-ga=\"Reverse Footnote\" href=\"#footnote-ref-#{@num}\" title=\"Back\">↩</a>"
      end
    end
  end
end

Liquid::Template.register_tag('reverse_footnote', Jekyll::Tags::ReverseFootnoteTag)