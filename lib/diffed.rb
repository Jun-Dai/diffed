require 'diffed/version'
require 'parsers/unified'
require 'escape_utils'

module Diffed
  def self.from_lines(lines)
    Diff.new(lines)
  end
  
  def self.from_text(text)
    Diff.new(text.split /\n/)
  end
  
  class Diff
    include Html
    attr_accessor :sections
    
    def initialize(lines)
      parse(lines)      
    end
    
    private    
    def parse(lines)
      @sections = UnifiedDiffParser.new(lines).parse!.sections
    end
  end
end
