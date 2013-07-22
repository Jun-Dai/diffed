module Diffed
  class DiffedFile
    attr_reader :file_desc, :sections
    
    def initialize(file_desc, sections)
      @file_desc, @sections = file_desc, sections
    end
  end
end