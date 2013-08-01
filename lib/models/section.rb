require 'formatters/diff_html'

module Diffed
  class Section
    include DiffHtml
    attr_reader :header, :lines
  
    def initialize(header, lines, row_nums_to_highlight = [])
      @header, @lines, @row_nums_to_highlight = header, lines, row_nums_to_highlight
    end
    
    def as_html_rows(use_inline_styles)
      html = format_section_header_row(use_inline_styles)
      lines.each_with_index do |line, i| 
        html << line.as_html_row(use_inline_styles, @row_nums_to_highlight.include?(i))
      end
      
      html
    end
    
    private
    def format_section_header_row(use_inline_styles)
      row = OutputRow.new(:left => "...", :right => "...", :text => header)

      if use_inline_styles
        format_styled_row '#F0F0FF', '#888', row
      else
        format_classed_row 'section', row
      end
    end
    
    def sections
      [self]
    end
  end  
end