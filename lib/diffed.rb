require "diffed/version"

module Diffed
  class Diff
    def initialize(raw_diff)
      parse(raw_diff.split(/\n/))      
    end
    
    def to_html
      left_line_num = @header.line_nums[:left][:from]
      right_line_num = @header.line_nums[:right][:from]

      html = "<tr class=\"section_head\"><td>...</td><td>...</td><td>#{@header.text}</td></tr>\n"
      
      @diff_lines.each_with_index do |line, i|
        html << "<tr class=\"#{line.type}\"><td>#{line.type == :right ? "." : left_line_num}</td>"
        html << "<td>#{line.type == :left ? "." : right_line_num}</td><td>#{line.text}</td></tr>\n"
        
        left_line_num += 1 unless line.type == :right
        right_line_num += 1 unless line.type == :left
      end
      html
    end
    
    private
    def parse(lines)
      # first line is special
      @header = DiffHeaderLine.new(lines[0])      
      @diff_lines = lines[1..lines.length].collect {|l| DiffLine.new(l)}
    end
  end
  
  class line
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
