require 'spec_helper'

describe "Diffed::Diff.as_html_table" do
  it "produces an html table representation of a diff, with CSS classes" do
    diff = Diffed::Diff.new(File.read("testdata/diff1.diff"))    
    output = diff.as_html_table
    output.strip == File.read("testdata/diff1.html").strip
  end
end