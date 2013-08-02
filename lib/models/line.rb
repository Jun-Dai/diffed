require 'formatters/diff_html'

module Diffed
  class Line
    include DiffHtml
    attr_reader :type, :text, :left_line_num, :right_line_num, :no_newline
  
    def initialize(type, text, left_line_num, right_line_num)
      @type, @text, @left_line_num, @right_line_num, @no_newline = type, text, left_line_num, right_line_num, false
    end
    
    def left?
      @type == :left || @type == :both
    end
  
    def right?
      @type == :right || @type == :both
    end    
  
    def no_newline= bool
      # mutability like this kind of sucks, but this one's a pain to avoid.
      @no_newline = bool
    end 
    
    def as_html_row(use_inline_styles, highlight = false)
      format_code_line(use_inline_styles, highlight)
    end  
    
    private
    def format_code_line(use_inline_styles, highlight)
      row = OutputRow.new(:code_line => self)
      
      if use_inline_styles
        format_styled_row code_line_color(highlight), '#000', row, :highlight => highlight, :border_color => border_color
      else
        format_classed_row type.to_s, row, :highlight => highlight
      end
    end
      
    def code_line_color(highlight)
      if highlight && type == :both
        '#FFFBCC'
      else      
        colors = {left: '#FDD', right: '#DFD', both: nil}
        colors[type]
      end
    end
    
    def border_color
      border_colors = {left: '#F55', right: '#5F5', both: '#999'}
      border_colors[type]
    end
  end
end