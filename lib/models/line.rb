module Diffed
  class Line
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
  end  
end