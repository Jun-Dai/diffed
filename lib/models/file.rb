require 'formatters/diff_html'

module Diffed
  class DiffedFile
    include html
    attr_reader :file_desc, :sections
    
    def initialize(file_desc, sections)
      @file_desc, @sections = file_desc, sections
    end
  end
end