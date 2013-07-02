require "diffed/version"

module Diffed
  class Diff
    def initialize(raw_diff)
      parse(raw_diff.split(/\n/))      
    end
    
    def as_html_table
      left_line_num = @header.line_nums[:left][:from]
      right_line_num = @header.line_nums[:right][:from]

      html = %Q{<table cellpadding="5" style="border-collapse: collapse; border: 1px solid \#CCC; font-family: Consolas, courier, monospace; font-size: 13px; color: #888">\n}
      html << format_tr_line('#F0F0FF', '#888', "...", "...", @header.text)
      
      @diff_lines.each_with_index do |line, i|
        html << make_tr_line(line, left_line_num, right_line_num)
        
        left_line_num += 1 unless line.type == :right
        right_line_num += 1 unless line.type == :left
      end

      html << "</table>"
    end
    
    private    
    def make_tr_line(line, left_line_num, right_line_num)
      case line.type
      when :left
        format_tr_line '#FDD', nil, left_line_num, ".", line.text
      when :right
        format_tr_line '#DFD', nil, ".", right_line_num, line.text
      when :both
        format_tr_line nil, nil, left_line_num, right_line_num, line.text
      end        
    end
    
    def format_tr_line(bg_color, text_color, left_num, right_num, text)
      row_style = bg_color.nil? ? "" : %Q{ style="background-color: #{bg_color}"}
      text_color = text_color || '#000'
      %Q{<tr#{row_style}><td style="border-left: 1px solid \#CCC">#{left_num}</td><td style="border-left: 1px solid \#CCC">#{right_num}</td><td style="border-left: 1px solid \#CCC; border-right: 1px solid \#CCC; color: #{text_color}">#{text}</td></tr>\n}
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
