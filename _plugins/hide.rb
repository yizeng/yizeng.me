require 'cgi'

module Jekyll
  module Tags
    class HideTag < Liquid::Block
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
      end

      def render(context)
        code = CGI.unescapeHTML(h(super).strip)
        "<div class=\"hidden\">#{code}</div>"
      end
    end
  end
end

Liquid::Template.register_tag('hide', Jekyll::Tags::HideTag)