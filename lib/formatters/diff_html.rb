module Diffed
  module DiffHtml
    def as_html_table(use_inline_styles=true, row_nums_to_highlight = [])
      html = make_table_tag(use_inline_styles)
      
      sections.each do |section|
        html << section.as_html_rows(use_inline_styles, row_nums_to_highlight)
      end

      html << "</table>"
    end
    
    private     
    def format_styled_row(bg_color, text_color, row, opts = {})      
      row_styles = []
      row_styles << "background-color: #{bg_color}" unless bg_color.nil?
      row_styles << "font-weight: bold" if opts[:highlight]
      
      row_style_attr = row_styles.empty? ? "" : %Q{ style="#{row_styles.join('; ')}" }
      text_color = text_color
      
      border = '1px solid #CCC'
      html = <<EOS
      <tr#{row_style_attr}>
        <td style="border-left: #{border}">#{row.left}</td>
        <td style="border-left: #{border}">#{row.right}</td>
        <td style="border-left: #{border}; border-right: #{border}; color: #{text_color}"><pre>#{row.text}</pre></td>
      </tr>
EOS
    end
    
    def format_classed_row(css_class, row, opts = {})
      class_attr = %Q{ class="#{css_class}#{opts[:highlight] ? ' highlight' : ''}"}
      %Q{<tr#{class_attr}><td>#{row.left}</td><td>#{row.right}</td><td><pre>#{row.text}</pre></td></tr>\n}
    end

    def make_table_tag(inline_styles)
      if inline_styles
        table_attributes = %Q{cellpadding="5" style="border-collapse: collapse; border: 1px solid \#CCC; font-family: Consolas, courier, monospace; font-size: 11px; color: #888"}
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