module Diffed
  class Section
    attr_reader :header, :lines
  
    def initialize(header, lines)
      @header, @lines = header, lines
    end    
  end  
end