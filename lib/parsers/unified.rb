require 'models/line'
require 'models/section'

module Diffed
  class UnifiedDiffParser
    def initialize(lines)
      @lines, @sections = lines, []
      reset_section!
    end

    def parse!
      raise "Already parsed into #{@sections.length} sections." unless @sections.empty?
      
      @lines.each do |line|
        if HeaderLineParser.is_header?(line)
          unless @curr_header.nil?
            raise "Found a header while still processing a section!  #{line}"
          end
          
          @curr_header, @curr_lines = HeaderLineParser.new(line), []
        elsif @curr_header.nil?
          # Do nothing.  We haven't started yet.
          # puts "Ignoring line: #{line}"
        elsif line =~ /\\ No newline at end of file/
          if @curr_lines.empty?
            @sections.last.lines.last.no_newline = true
          else
            @curr_lines.last.no_newline = true
          end
        else
          line_parser = LineParser.new(line)          
          @left_counter, @right_counter = line_parser.increment(@left_counter, @right_counter)          
          @curr_lines << line_parser.line(@left_counter, @right_counter)
          
          if @curr_header.section_complete? @left_counter, @right_counter
            @sections << Section.new(@curr_header.line, @curr_lines)
            reset_section!
          end
        end
      end      
      
      self
    end
    
    def sections
      raise "Not parsed.  Call parse! before attempting to read sections from the parser." if @sections.empty?
      @sections
    end
    
    private
    def reset_section!
      @curr_header, @curr_lines, @left_counter, @right_counter = nil, [], 0, 0
    end 
  
    class LineParser
      def initialize(line_text)
        @line_text = line_text
        
        if line_text.start_with? "-"
          @type = :left
        elsif line_text.start_with? "+"
          @type = :right      
        elsif line_text.start_with? " "
          @type = :both               
        else
          raise "Unparseable line: #{line}"
        end
      end
      
      def increment(left_counter, right_counter)
        case @type
        when :left
          [left_counter + 1, right_counter]
        when :right
          [left_counter, right_counter + 1]
        when :both
          [left_counter + 1, right_counter + 1]
        end
      end
      
      def line(left_counter, right_counter)
        Line.new(@type, @line, left_counter, right_counter)        
      end
    end
  
    class HeaderLineParser
      attr_reader :line_nums, :text
    
      def initialize(line)
        @text = line
      
        if line =~ /^@@ -(\d+),(\d+) \+(\d+),(\d+) @@/        
          @line_nums = {left: {from: $1.to_i, lines: $2.to_i}, right: {from: $3.to_i, lines: $4.to_i}}
        elsif line =~ /^@@ -(\d+) \+(\d+) @@/
          @line_nums = {left: {from: $1.to_i, lines: $1.to_i}, right: {from: $2.to_i, lines: $2.to_i}}
        else
          raise "Unparseable header line: #{line}"
        end
      
        if @line_nums[:right][:lines] > @line_nums[:left][:lines]
          @side_to_count = :right
        else
          @side_to_count = :left
        end      
      end
    
      def self.is_header?(line)
        line.start_with? "@@ "
      end
    
      def section_complete?(left_count, right_count)
        left_count >= @line_nums[:left][:lines] && right_count >= @line_nums[:right][:lines]
      end
      
      def line
        @text
      end
    end  
  end
end