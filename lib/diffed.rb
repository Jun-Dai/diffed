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
    def initialize(lines)
      parse(lines)      
    end
    
    def as_html_table(use_inline_styles = true)
      html = make_table_tag(use_inline_styles)
      
      @sections.each do |section|
        html << format_section_header_row(section.header, use_inline_styles)        
        section.lines.each_with_index do |line, i|
          html << format_code_line(line, use_inline_styles)
        end
      end

      html << "</table>"
    end
    
    private
    def format_code_line(line, use_inline_styles)
      row = OutputRow.new(:code_line =>line)
      
      if use_inline_styles
        format_styled_row code_line_style(line), '#000', row
      else
        format_classed_row line.type.to_s, row
      end
    end
      
    def code_line_style(line)
      case line.type
      when :left
        '#FDD'
      when :right
        '#DFD'
      when :both
        nil
      end
    end
        
    def format_section_header_row(header, use_inline_styles)
      row = OutputRow.new(:left => "...", :right => "...", :text => header)

      if use_inline_styles
        format_styled_row '#F0F0FF', '#888', row
      else
        format_classed_row 'section', row
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
    
    def format_styled_row(bg_color, text_color, row)
      row_style = bg_color.nil? ? "" : %Q{ style="background-color: #{bg_color}"}
      text_color = text_color
      
      %Q{<tr#{row_style}><td style="border-left: 1px solid \#CCC">#{row.left}</td><td style="border-left: 1px solid \#CCC">#{row.right}</td><td style="border-left: 1px solid \#CCC; border-right: 1px solid \#CCC; color: #{text_color}"><pre>#{row.text}</pre></td></tr>\n}
    end
    
    def format_classed_row(css_class, row)
      %Q{<tr class="#{css_class}"><td>#{row.left}</td><td>#{row.left}</td><td><pre>#{row.text}</pre></td></tr>\n}
    end
    
    def parse(lines)
      @sections = UnifiedDiffParser.new(lines).parse!.sections
    end
    
    class OutputRow
      attr_reader :left, :right
      
      def initialize(params = {})
        if params[:code_line].nil?
          @left, @right, @text = params[:left], params[:right], params[:text]
        else
          line = params[:code_line]
          @left, @right, @text = line.left_line_num, line.right_line_num, line.text
        end
      end
      
      def text
        EscapeUtils.escape_html(@text, false)
      end
    end
  end
end
