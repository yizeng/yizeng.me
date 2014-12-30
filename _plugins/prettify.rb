module Jekyll
  module Tags
    class PrettifyBlock < Liquid::Block
      include Liquid::StandardFilters

      SYNTAX = /^([a-zA-Z0-9.+#-]*)((\s+\w+(=\d+)?)*)$/

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
            @lang = defined?($1) && $1 != ''  ? " lang-#{$1.downcase}" : ""
            if defined?($2) && $2 != ''
              key, value = $2.split('=')
              @linenums = " linenums" + (value.nil? ? '' : ":#{value}")
            end
        else
            raise SyntaxError.new <<-eos
  Syntax Error in tag 'prettify' while parsing the following markup:

    #{markup}

  Valid syntax: prettify [lang] [linenos]
  eos
        end
      end

      def render(context)
        code = h(super).strip

        <<-HTML
<div><pre class="prettyprint#{@lang}#{@linenums}"><code>#{code}</code></pre></div>
        HTML
      end
    end
  end
end

Liquid::Template.register_tag('prettify', Jekyll::Tags::PrettifyBlock)