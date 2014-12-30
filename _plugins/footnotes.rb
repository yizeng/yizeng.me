require 'cgi'

module Jekyll
  module Tags
    class FootnotesBlock < Liquid::Block
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
      end

      def render(context)
        code = CGI.unescapeHTML(h(super).strip)
        "<div class=\"footnotes\"><hr />#{code}</div>"
      end
    end
  end
end

Liquid::Template.register_tag('footnotes', Jekyll::Tags::FootnotesBlock)