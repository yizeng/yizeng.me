require 'cgi'

module Jekyll
  module Tags
    class DataTableBlock < Liquid::Block
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
      end

      def render(context)
        code = CGI.unescapeHTML(h(super).strip)
        "<div class=\"data-table\"><table>#{code}</table></div>"
      end
    end
  end
end

Liquid::Template.register_tag('datatable', Jekyll::Tags::DataTableBlock)