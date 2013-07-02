require "diffed/version"

module Diffed
  class Diff
    def initialize(raw_diff)
      parse(raw_diff.split(/\n/))      
    end
    
    def as_html_table(inline_styles = true)
      left_line_num = @header.line_nums[:left][:from]
      right_line_num = @header.line_nums[:right][:from]

      html = make_table_tag(inline_styles)
      html << make_section_header_row(inline_styles)
      
      @diff_lines.each_with_index do |line, i|
        html << make_tr_line(line, left_line_num, right_line_num, inline_styles)
        
        left_line_num += 1 unless line.type == :right
        right_line_num += 1 unless line.type == :left
      end

      html << "</table>"
    end
    
    private
    def make_tr_line(line, left_line_num, right_line_num, inline_styles)
      if inline_styles
        make_styled_tr_line line, left_line_num, right_line_num
      else
        make_classed_tr_line line, left_line_num, right_line_num
      end
    end
      
    def make_styled_tr_line(line, left_line_num, right_line_num)
      case line.type
      when :left
        format_styled_tr_line '#FDD', nil, left_line_num, ".", line.text
      when :right
        format_styled_tr_line '#DFD', nil, ".", right_line_num, line.text
      when :both
        format_styled_tr_line nil, nil, left_line_num, right_line_num, line.text
      end        
    end
    
    def make_classed_tr_line(line, left_line_num, right_line_num)
      case line.type
      when :left
        format_classed_tr_line "left", left_line_num, ".", line.text
      when :right
        format_classed_tr_line "right", ".", right_line_num, line.text
      when :both
        format_classed_tr_line "both", left_line_num, right_line_num, line.text
      end        
    end
    
    def make_section_header_row(inline_styles)
      if inline_styles
        format_styled_tr_line('#F0F0FF', '#888', "...", "...", @header.text)
      else
        format_classed_tr_line('section', "...", "...", @header.text)
      end
    end
    
    def make_table_tag(inline_styles)
      if inline_styles
        table_attributes = %Q{cellpadding="5" style="border-collapse: collapse; border: 1px solid \#CCC; font-family: Consolas, courier, monospace; font-size: 13px; color: #888"}
      else
        table_attributes = %Q{class="coloured-diff"}
      end
      
      %Q{<table #{table_attributes}>\n}
    end
    
    def format_styled_tr_line(bg_color, text_color, left_num, right_num, text)
      row_style = bg_color.nil? ? "" : %Q{ style="background-color: #{bg_color}"}
      text_color = text_color || '#000'
      
      %Q{<tr#{row_style}><td style="border-left: 1px solid \#CCC">#{left_num}</td><td style="border-left: 1px solid \#CCC">#{right_num}</td><td style="border-left: 1px solid \#CCC; border-right: 1px solid \#CCC; color: #{text_color}">#{text}</td></tr>\n}
    end
    
    def format_classed_tr_line(css_class, left_num, right_num, text)
      %Q{<tr class="#{css_class}"><td>#{left_num}</td><td>#{right_num}</td><td>#{text}</td></tr>\n}
    end
    
    def parse(lines)
      # first line is special
      @header = DiffHeaderLine.new(lines[0])      
      @diff_lines = lines[1..lines.length].collect {|l| DiffLine.new(l)}
    end
  end
  
  class DiffLine
    attr_reader :type, :text
    
    def initialize(line)
      if line.start_with? "-"
        @type = :left
      elsif line.start_with? "+"
        @type = :right
      elsif line.start_with? " "
        @type = :both
      else
        raise "Unparseable line: #{line}"
      end
      
      @text = line
    end
  end
  
  class DiffHeaderLine
    attr_reader :line_nums, :text
    
    def initialize(line)
      if line =~ /^@@ -(\d+),(\d+) \+(\d+),(\d+) @@$/
        @text = line
        @line_nums = {left: {from: $1.to_i, to: $2.to_i}, right: {from: $1.to_i, to: $2.to_i}}
      else
        raise "Unparseable header line: #{line}"
      end
    end
  end
end
