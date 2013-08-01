module Diffed
  module Html
    def as_html_table(use_inline_styles=true)
      html = make_table_tag(use_inline_styles)
      
      sections.each do |section|
        html << section.as_html_rows(use_inline_styles)
      end

      html << "</table>"
    end
    
    private     
    def format_styled_row(bg_color, text_color, row)
      row_style = bg_color.nil? ? "" : %Q{ style="background-color: #{bg_color}"}
      text_color = text_color

      %Q{<tr#{row_style}><td style="border-left: 1px solid \#CCC">#{row.left}</td><td style="border-left: 1px solid \#CCC">#{row.right}</td><td style="border-left: 1px solid \#CCC; border-right: 1px solid \#CCC; color: #{text_color}"><pre>#{row.text}</pre></td></tr>\n}
    end
    
    def format_classed_row(css_class, row)
      %Q{<tr class="#{css_class}"><td>#{row.left}</td><td>#{row.left}</td><td><pre>#{row.text}</pre></td></tr>\n}
    end

    def make_table_tag(inline_styles)
      if inline_styles
        table_attributes = %Q{cellpadding="5" style="border-collapse: collapse; border: 1px solid \#CCC; font-family: Consolas, courier, monospace; font-size: 13px; color: #888"}
      else
        table_attributes = %Q{class="coloured-diff"}
      end
      
      %Q{<table #{table_attributes}>\n}
    end
    
    class OutputRow
      attr_reader :left, :right
      
      def initialize(params = {})
        if params[:code_line].nil?
          @left, @right, @text = params[:left], params[:right], params[:text]
        else
          line = params[:code_line]
          @left, @right, @text = line.left_line_num, line.right_line_num, line.text
        end
      end
      
      def text
        EscapeUtils.escape_html(@text, false)
      end
    end
  end
end